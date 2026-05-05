class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/releases/download/v3.6.16/traefik-v3.6.16.src.tar.gz"
  sha256 "62cfb5148161656e743f0f457a4cc5edd5033e9c2779d48568ce1fc93b0cb732"
  license "MIT"
  head "https://github.com/traefik/traefik.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47fcdbc9c1a761f1c06547764b791d641136a6dcb613c481ccea4106515b8713"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bcabbe5920fc3f2e774d2bfa3270c29d7641291881be4a1e6badf246bf7a20d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f208c63aea3c06cd396aa1d46e113f39e2b3105572c15043a0ba16978cdf978"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee4b8234d90434d164baca19d3e636e822ef77d67411a16d1293e4b44176e8ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c80a63f316e03ce4a999b9b5966272195fba17161cac4d90b704e8b7896860b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95bf38f57c30b883a6785fcfb84d30710333e9524ebc04d5292ce958da7ff89d"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "corepack", "enable", "--install-directory", buildpath

    cd "webui" do
      system buildpath/"yarn", "install"
      system buildpath/"yarn", "build"
    end

    ldflags = %W[
      -s -w
      -X github.com/traefik/traefik/v#{version.major}/pkg/version.Version=#{version}
    ]
    system "go", "generate"
    system "go", "build", *std_go_args(ldflags:), "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc}/traefik/traefik.toml"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~TOML
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    TOML

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 8
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd_ui)

      # Make sure webui assets for dashboard are present at expected destination
      cmd_ui = "curl -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match "<title>Traefik Proxy</title>", shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
