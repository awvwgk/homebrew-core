class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.3.tgz"
  sha256 "1c11889227c3a71d04a64c1c0e89c7efd9757f1969e75caeb31ca90d75fb6434"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3c81f07386423fd33cde65ad233ebbdd96820a889af11610ab0df13252884e2"
    sha256 cellar: :any,                 arm64_sequoia: "3368f0e42be7daad949192b736c0d19ee02a700290d61f93ae4fa667244bee95"
    sha256 cellar: :any,                 arm64_sonoma:  "3368f0e42be7daad949192b736c0d19ee02a700290d61f93ae4fa667244bee95"
    sha256 cellar: :any,                 sonoma:        "dcb8a08c4190975dc3ce5bc727ab67c431ed233bba8a8c6b59d863482a4d85ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4188484a8d958fc901bf8c72c75928a8030660c0e1b2cf2f9544ffc315b4e621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f26922431fa6a80b07bd39c4d6c991ff84b0432593d6a52a0322ca27d1ff9dcd"
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
