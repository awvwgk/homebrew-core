class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.71.1.tgz"
  sha256 "38f9582df815abd1666c834c8b1cc5926c655939a6181a8bc021def60d6b6c49"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f699df8d803eaf801944eff513f91c4fa127158bf007904392bf2ce0d4400e7"
    sha256 cellar: :any,                 arm64_sequoia: "42ad5518de359a8730d6f02fc6601ae1d089f47e2f232c77bba182d1ca7c395f"
    sha256 cellar: :any,                 arm64_sonoma:  "42ad5518de359a8730d6f02fc6601ae1d089f47e2f232c77bba182d1ca7c395f"
    sha256 cellar: :any,                 sonoma:        "f4ab9bedc4d6ae0ce3b9442b736c8690672990115a7f57a7c8e77ac6551406c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc6f5f4e665e9934cd7d2da268d0cfe33cc6b286bf3069edec49ee51c5256909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2deaa16f2928bc6b050632190d149cac8c397bd21706952134aba13f3a12faca"
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
