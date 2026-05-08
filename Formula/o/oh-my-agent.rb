class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.16.1.tgz"
  sha256 "860dbe10409fb5f2c350024b9121bc54aa05b8d05ab6568f5f92f134263a7cbd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9505a96a4f7f88a5ac8b05774d9ce41c493a651765403eaa9c55e539e77fec69"
    sha256 cellar: :any,                 arm64_sequoia: "0226f4892b81497bba404f8c38e5e6fedf73d9daece561acf7410954473e8a89"
    sha256 cellar: :any,                 arm64_sonoma:  "0226f4892b81497bba404f8c38e5e6fedf73d9daece561acf7410954473e8a89"
    sha256 cellar: :any,                 sonoma:        "14313550ef195c919bc2a83ab15b848445261c4819c319aac39b8f929f633440"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0459563ce627c71ea743c86ba6b22095ada1d5670d85c3afed900e332408886"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f3625fbb7203879750e706427ce750f2511ae56157946c06719ef692bcd04e9"
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
