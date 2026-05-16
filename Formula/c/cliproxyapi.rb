class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.5.tar.gz"
  sha256 "0ecfad512519cdf546ef43b6d2e8712c5956ff746527943ce4e7ef0a49544aed"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "20184de305abf7ce9bc766d0b61894c1191edd2abd9637c05efba4de07a1a25a"
    sha256 arm64_sequoia: "20184de305abf7ce9bc766d0b61894c1191edd2abd9637c05efba4de07a1a25a"
    sha256 arm64_sonoma:  "20184de305abf7ce9bc766d0b61894c1191edd2abd9637c05efba4de07a1a25a"
    sha256 sonoma:        "cf9b67b31db67587301593e94ebafbb33dd2c40f09dae3c924772edeb152bbe2"
    sha256 arm64_linux:   "6605f847a5a89bbba7cdaab169b28591eed3c99f5696ce7a465443cb67e6dec1"
    sha256 x86_64_linux:  "fb9f646e489dcb8667732a97456fe13acf1a60b5971b21381b0f6728bfa3ce65"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.BuildDate=#{time.iso8601}
      -X main.DefaultConfigPath=#{etc/"cliproxyapi.conf"}
    ]

    system "go", "build", *std_go_args(ldflags:), "cmd/server/main.go"
    etc.install "config.example.yaml" => "cliproxyapi.conf"
  end

  service do
    run [opt_bin/"cliproxyapi"]
    keep_alive true
  end

  test do
    require "pty"
    PTY.spawn(bin/"cliproxyapi", "-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end
