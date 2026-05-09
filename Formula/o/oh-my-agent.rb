class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.17.0.tgz"
  sha256 "e57f715f3fbd669d464f377f4d2c4a57bf97429978ee86c4c47880fc4518e9bd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aac403f48d9f894474e06fefef2242642e25a9f5c11bb5b26a4d3090a27b2e74"
    sha256 cellar: :any,                 arm64_sequoia: "60ea792e3e305ff8ce0e87b2ab4814997207b3a8ebeb008998729338861efa3c"
    sha256 cellar: :any,                 arm64_sonoma:  "60ea792e3e305ff8ce0e87b2ab4814997207b3a8ebeb008998729338861efa3c"
    sha256 cellar: :any,                 sonoma:        "528e433ce1bc56c8956590719879f37563eb6840320617fbd35ad8bb5351fc2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a35ffabc4108fe09b8c0a1a7a0832ed5df97ed530fc4631cfd510c283348d659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c958e5dbe42a5787256a3840bc933931181bc6e645aafd9c7fe723839afb133d"
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
