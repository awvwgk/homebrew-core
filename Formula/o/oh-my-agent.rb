class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.10.0.tgz"
  sha256 "ba03f68dcd94a7444740c90eef4a08a96213041860f6054b3e3fcc26e8073b64"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0547088402cfe53b14bb28b4a1a99633c30bbc3b15edd882b39ed5590049656a"
    sha256 cellar: :any,                 arm64_sequoia: "d009d7a1d6c4dc1261d3613b40bf2faa7a14aadfd155765137f02803bc678e6e"
    sha256 cellar: :any,                 arm64_sonoma:  "d009d7a1d6c4dc1261d3613b40bf2faa7a14aadfd155765137f02803bc678e6e"
    sha256 cellar: :any,                 sonoma:        "7560751a22d6ea3a94078df75bcbcb6df3071b877ba9434829fb5bb1868ecfd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96a08e4c98c1f51db6f34465ce367c55e7a184cb5e8dd6438f63714b367716d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9a41e99ec63ed0db2e1bacf9f3d494d71193ee527511d4b623469783704b7b7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
