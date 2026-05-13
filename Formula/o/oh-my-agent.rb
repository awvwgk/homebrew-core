class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.10.0.tgz"
  sha256 "ba03f68dcd94a7444740c90eef4a08a96213041860f6054b3e3fcc26e8073b64"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a94ff1e6125baeae846cadff84866793d541e084a39393bf7115d2dc658de09a"
    sha256 cellar: :any,                 arm64_sequoia: "7c47272eaca0ad65b05c21ef6d2c27af4ca0fde030482754c3a97baccfb3cc64"
    sha256 cellar: :any,                 arm64_sonoma:  "7c47272eaca0ad65b05c21ef6d2c27af4ca0fde030482754c3a97baccfb3cc64"
    sha256 cellar: :any,                 sonoma:        "4b84a2c277bdc0f28021890ab05896f247229e383125b91c1eec159dfe0cea1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c84277d3e2b523c7723e3eb92b6f26515e85ec9691a09bfba86a77be9315cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "118e5b7e3dca9c2649b15a78b814d4eacc1f41865e28c6f2377f2e9700b8e6b8"
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
