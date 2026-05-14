class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/seaweedfs/seaweedfs"
  url "https://github.com/seaweedfs/seaweedfs.git",
      tag:      "4.24",
      revision: "1dfea8a5027207b2bdf7036c63793391ae51ab9d"
  license "Apache-2.0"
  head "https://github.com/seaweedfs/seaweedfs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a56b65f79b1cebe6b82e315808388485bc0d67a65251fad36b793377f3d45849"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cb49856d24c4f3be547b32def1a675ed068ff8ea4540c3e57cfedc627b79fbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40e0cab86c08607a75e793355a50fbd928630245e8c8530cc7d556a3aa21b533"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4b58fa1c3e99533efe721cf1d610262dab89724f3ffe9bd4fdc6cf0194192fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b4fa453e67be53a8585a794e91f45e49ae12390cb50afddf45b0f925bb14335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7a17f77bea36a25263b638de4ecb6dd8d70ea73f500c525af6a4cb099fd5bd5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/seaweedfs/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"weed"), "./weed"
  end

  def post_install
    (var/"seaweedfs").mkpath
  end

  service do
    run [opt_bin/"weed", "server", "-dir=#{var}/seaweedfs", "-s3"]
    keep_alive true
    error_log_path var/"log/seaweedfs.log"
    log_path var/"log/seaweedfs.log"
    working_dir var
  end

  test do
    # Start SeaweedFS master server/volume server
    master_port = free_port
    volume_port = free_port
    master_grpc_port = free_port
    volume_grpc_port = free_port

    spawn bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
          "-master.port=#{master_port}", "-volume.port=#{volume_port}",
          "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    sleep 30

    # Upload a test file
    fid = JSON.parse(shell_output("curl http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
