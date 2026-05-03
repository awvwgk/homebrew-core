class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.72.0.tgz"
  sha256 "bb510dde5bfa923d18fe677f7f35d53f095000e78da3c7f6e05c7433a0aab518"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b892e4d7ac1408211056fc2d3e6dec3917845a289489616275f64f1037def41"
    sha256 cellar: :any,                 arm64_sequoia: "f543e9e8d7c207142bb6f8be0f345d4ab266c1035befc192aee4a2431fb1b591"
    sha256 cellar: :any,                 arm64_sonoma:  "f543e9e8d7c207142bb6f8be0f345d4ab266c1035befc192aee4a2431fb1b591"
    sha256 cellar: :any,                 sonoma:        "4ba4354b89338dee7f86068caf20b888a39545d9818486d6d73d0b9d61e1938a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "998901f2d1c4863770d78a6d4088cf76d366517c3602ea6e1a6ad79aee33eb25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a7470d9764a652ad29a39f75428f5eef40e84efafe2890b9593765338911d25"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@mariozechner/pi-coding-agent/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end
