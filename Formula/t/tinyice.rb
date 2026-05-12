class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://github.com/DatanoiseTV/tinyice"
  url "https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "65faf312975b6f7bcb4e929bc00ee6826cae9d54088a99b63ffa9268a730b54a"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2305d0b7cad8fd9b8aebab97b1c27a7eb0e971756fe73bd3244e4e74fda5e896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2305d0b7cad8fd9b8aebab97b1c27a7eb0e971756fe73bd3244e4e74fda5e896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2305d0b7cad8fd9b8aebab97b1c27a7eb0e971756fe73bd3244e4e74fda5e896"
    sha256 cellar: :any_skip_relocation, sonoma:        "a676e0d4ea0ac68c580d842646c61d9124ba5b9940bbdbfcb171dd5267479a52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78bb1a46750874db0682c5dfb946b3454ba6457b6b2e916a82dcd31ea05e3548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da58ee00729ea67deddea2a89af67c1dbe4fab2b1cfa27b60746acdca2d71ef"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"tinyice"]
    keep_alive true
    working_dir var/"tinyice"
    log_path var/"log/tinyice.log"
    error_log_path var/"log/tinyice.log"
  end

  test do
    port = free_port

    # Write minimal config
    (testpath/"tinyice.json").write <<~JSON
      {
        "bind_host": "127.0.0.1",
        "port": "#{port}",
        "admin_user": "admin",
        "admin_password": "test"
      }
    JSON

    pid = spawn bin/"tinyice", chdir: testpath
    sleep 3

    begin
      output = shell_output("curl -s --fail http://127.0.0.1:#{port}/")
      assert_match("TinyIce", output)
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
