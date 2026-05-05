class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.8.0.tgz"
  sha256 "a0399addc924bdabc097b0ea316c6154924a248549c1cc98e523010e740aa116"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b69405500aeed5dfee2d1b036520d8f0adf69dbfcb994c702c45618501310e8"
    sha256 cellar: :any,                 arm64_sequoia: "0836698e37f920ee003732731ac2402fed0819accf7d6ceb3af2bbda4ea00787"
    sha256 cellar: :any,                 arm64_sonoma:  "0836698e37f920ee003732731ac2402fed0819accf7d6ceb3af2bbda4ea00787"
    sha256 cellar: :any,                 sonoma:        "23f420ce9a4cdc7ed342e184bd50f2ccd942399559e41eceb6912b3c8d67409f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac26256577dcc5517f0e68f34fa5f776863dbb332c18428d16b1cec418b6dd70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e3fc31be9ad701f83f4681f5d210509ac17e23d93f50be93207371ccd1ff69e"
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
