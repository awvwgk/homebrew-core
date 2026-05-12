class Tinyice < Formula
  desc "Modern, all-in-one Icecast-compatible audio/video streaming server"
  homepage "https://github.com/DatanoiseTV/tinyice"
  url "https://github.com/DatanoiseTV/tinyice/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "9e43e9c7dec8f5263c692a3c752ac07dc5ce208dec7e76a66bb4a7f23aff5e4e"
  license "Apache-2.0"
  head "https://github.com/DatanoiseTV/tinyice.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed82fafac45f77a63c64c9caa4f9e85cc1c05eed43c75f3604480d3c5d9c5bd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed82fafac45f77a63c64c9caa4f9e85cc1c05eed43c75f3604480d3c5d9c5bd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed82fafac45f77a63c64c9caa4f9e85cc1c05eed43c75f3604480d3c5d9c5bd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9aba594ba129f61484f10b27107778e33e1516a718206cf16946e8adcbb3331a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4d77931138516d9b0d922daff9ab2745ed6dab9db3b4eb4f90de85dd20a5262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16ff330eeaa0d230f0a6242e88533324ba5435545d4cde4f405b2314c86f6393"
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
