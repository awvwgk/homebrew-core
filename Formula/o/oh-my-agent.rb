class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.12.1.tgz"
  sha256 "4d0a0327c85262cbff9d93dad6d05217088e11a9c744c830fbd731d6bcf5836c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e15a6229e56e6358758f4de426d8932c7261ba632adcea3d52b9e47382c4b8db"
    sha256 cellar: :any,                 arm64_sequoia: "48b41bd144320d40b7f6bffc166261fed8e6c6c40c8fb8385fc1ba7450af201e"
    sha256 cellar: :any,                 arm64_sonoma:  "48b41bd144320d40b7f6bffc166261fed8e6c6c40c8fb8385fc1ba7450af201e"
    sha256 cellar: :any,                 sonoma:        "c11428a7aa490e5224f30cb63addd54b6378c50d9e8110adcf5c5c71126acaa0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f2a17f9c9e72ae033f539b39f8d18384dfd0d84e66c83e188c470ab0914848d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "377d9c0d8e61249966ce12b93cefd8873fb070f8b1770b30d6b07d2e531c9bf8"
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
