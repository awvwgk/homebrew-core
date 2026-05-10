class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.2.0.tgz"
  sha256 "1228c7ee771f24c4631dbf5c9e25796ec58d2a54367321b14dbcef437c2ca965"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d51ee56e94479d12ddfbcf7c3dcf5f4875920c9fc182c9be2a2135e5a8d046b9"
    sha256 cellar: :any,                 arm64_sequoia: "641c01066b586ff144512f626bbb6b4f7c0f848afd6c2b05cc50db8f6cd76093"
    sha256 cellar: :any,                 arm64_sonoma:  "641c01066b586ff144512f626bbb6b4f7c0f848afd6c2b05cc50db8f6cd76093"
    sha256 cellar: :any,                 sonoma:        "d175aa2888377ff582e943f612f4238ede62a82bfdc1d3c4d8b8f79ad7755209"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f6ef64bb584abef3be69ac8b7d52ea505b3c1496153ad69b5071c0bb37bd101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcc5d9fa1af98c571b07da93743ae1956b537bbdf78ab3ace3509c675bf9989e"
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
