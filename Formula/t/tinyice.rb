class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://github.com/DatanoiseTV/tinyice"
  url "https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "f54d5957f67d4229648b59b0e9c4c40d07f53fac7fbeb0245a1f2654322bdc4c"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e99aa8d6743caa29830be7a61e4bda25fe14a45a6266a6b94da6545c036402f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e99aa8d6743caa29830be7a61e4bda25fe14a45a6266a6b94da6545c036402f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e99aa8d6743caa29830be7a61e4bda25fe14a45a6266a6b94da6545c036402f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d8a542453d21fefdc11904857eedfe588394fd0fce149300483df30219ff830"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5585b36c5abcfcd45b1b0c7769f3efe03cc15318a9f3db3b55614426beb3ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9252342e937b3d7f8fdc2cd9640d832b186219fa5a82a8a7a03eca6fa57aa97b"
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
