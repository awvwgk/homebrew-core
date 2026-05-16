class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.13.0.tgz"
  sha256 "10c0990959d15fb2ff4ac5595ddb33e755b63a606e55b7836a2b2e6f73aaf5dc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c802220f5f28b27ce134569671b983eca65d1ab8df442d5980cabb7987cdaf1b"
    sha256 cellar: :any,                 arm64_sequoia: "067ab0f3392f27a867dd0464f6413e8a9f3ce5674e766c8a3d163b9004bf83e1"
    sha256 cellar: :any,                 arm64_sonoma:  "067ab0f3392f27a867dd0464f6413e8a9f3ce5674e766c8a3d163b9004bf83e1"
    sha256 cellar: :any,                 sonoma:        "f0d8ed793fb4bfdd4d071e8d2350f86cc107581d43170dcb4722c5b7429bdc05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baf0207683dcb4caea17cc940acd1dd8e661d68fadef9cf715c8c754f3337b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96a7167a0bc2b3929a1f4c8ca329939585b9f4ffcb09b36e0f9cc915a70589e6"
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
