class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.8.0.tgz"
  sha256 "a0399addc924bdabc097b0ea316c6154924a248549c1cc98e523010e740aa116"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33d11d10d666b8caad57e397b3d697869fe643da77c05e40caa538f893bc2466"
    sha256 cellar: :any,                 arm64_sequoia: "8966ef7f48f93c93d95721e3df2f3975a2a981541736c34407c7101a008c5c30"
    sha256 cellar: :any,                 arm64_sonoma:  "8966ef7f48f93c93d95721e3df2f3975a2a981541736c34407c7101a008c5c30"
    sha256 cellar: :any,                 sonoma:        "6fe3262bcdad84b701dd082776a00546225032fb1a3abd22e941c530d2a6422a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f6daf6817983feb786ad00d7ee1c6e7ac910198eb33108b1e67a1809ab0292c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecf719f1104a8866667b5f7a709d9d17652fb82ece6da706f62c850f6c7f565b"
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
