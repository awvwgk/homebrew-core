class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.14.0.tgz"
  sha256 "2e242331f73e7ab93a75a24c5a9d36f722df2f1f7a7359c43c961ba3474e5863"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80cdeb1b16cb7600baf40379b652db14c8f1d45a8d0c17525fad24e5bf6f794e"
    sha256 cellar: :any,                 arm64_sequoia: "8f114f7b4c2a232a99912e5ca36bbaed195573de4fa1eff6bd6312d13dd0e215"
    sha256 cellar: :any,                 arm64_sonoma:  "8f114f7b4c2a232a99912e5ca36bbaed195573de4fa1eff6bd6312d13dd0e215"
    sha256 cellar: :any,                 sonoma:        "4148f3c6fb5f0aab035c6fb96a673f935b06c51f5ed5f709d27560b7cd6e328e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52fbd205441838f42e3b373772cfb3d2b72b2aaa4fb477a8b750a05ec47bc946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c079554c0b158418f0ec98a6754b848eaa4130cef27a7bd9dcfc7cc13d6b85bd"
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
