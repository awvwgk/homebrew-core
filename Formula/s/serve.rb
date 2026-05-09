class Serve < Formula
  desc "Static http server anywhere you need one"
  homepage "https://github.com/syntaqx/serve"
  url "https://github.com/syntaqx/serve/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "5616aa40a41105c94e8241883da8f1cfd44e70c4ec35e450533d6be0f4a14cf1"
  license "MIT"
  head "https://github.com/syntaqx/serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfce8144afb255617770210763548d39d828e46e19fee3dfe4c9781fdbd8c25d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfce8144afb255617770210763548d39d828e46e19fee3dfe4c9781fdbd8c25d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfce8144afb255617770210763548d39d828e46e19fee3dfe4c9781fdbd8c25d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ceaec060d2d211186be17f5129efc138b9feb2b4588c8c8fb81cd34335a4b05c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff0a3dc0f2934c910d54fb62e916de939aaa4e18ae0ce5852b68ed4c62270ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee9d0d611aaea85fbb2362847f4ff7da499ddf59a5429ff202f86995ddcb1079"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/serve"
  end

  test do
    port = free_port
    pid = spawn bin/"serve", "-port", port.to_s
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
