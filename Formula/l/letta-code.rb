class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.0.tgz"
  sha256 "52e3ce7c9d24b9fcabb13d73d1fc217805d2a32fe02b9c05cb99817f9ccc6d75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3bc9444667c275c1be6ebee4cdb91ecf3c72500c85b94e77b263b051a5b98b8b"
    sha256 cellar: :any,                 arm64_sequoia: "53e49ba0753647f570b157dc610a9ec62872a29dd636b688a5ecd6970da8adcc"
    sha256 cellar: :any,                 arm64_sonoma:  "53e49ba0753647f570b157dc610a9ec62872a29dd636b688a5ecd6970da8adcc"
    sha256 cellar: :any,                 sonoma:        "f5d0a4dcdc58268d747e9f88af78cbcd8696f7140cd8382bd3256758d565860a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed28b656a8369a8780ba1e22c504456168a80b643acb68d5682576233be4d923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a97b813991821114a796011a480fbfcbf6a6e9376b0fee57003f28090a253b0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
