class GoHassAgent < Formula
  desc "Native Home Assistant agent for desktop/laptop devices"
  homepage "https://github.com/joshuar/go-hass-agent"
  url "https://github.com/joshuar/go-hass-agent/archive/refs/tags/v14.11.0.tar.gz"
  sha256 "cf84fd68642bfa0da584c7cf267cfe471dfe61c94534cf23e09ef09428110596"
  license "MIT"

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on :linux

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build:js"
    system "npm", "run", "build:css"
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/joshuar/go-hass-agent/config.AppVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"go-hass-agent")
  end

  service do
    run [opt_bin/"go-hass-agent", "run"]
    keep_alive true
    working_dir var
    log_path var/"log/go-hass-agent.log"
    error_log_path var/"log/go-hass-agent.log"
  end

  test do
    # test UI load, primarily
    port = free_port
    hostname = "127.0.0.1"
    addr = "http://#{hostname}:#{port}"
    pid = spawn bin/"go-hass-agent", "run", "--server-port=#{port}", "--server-hostname=#{hostname}"
    sleep 3
    assert_match "Register", shell_output("curl #{addr}/register")
  ensure
    Process.kill("TERM", pid)
  end
end
