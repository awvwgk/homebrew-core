class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.6.0.tgz"
  sha256 "a6a5cb1083bff1fd4f66f9109f8fd6c639e84a2a50866fc4491924e5185fdc74"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea1119085cb66c670beefe43bfe9a6d56ce7f92cb61b70f4e705fcd301e13c6b"
    sha256 cellar: :any,                 arm64_sequoia: "f8abfac605da31942b0d024af1c6782962e90c10de0d80ab272ea0fadc671569"
    sha256 cellar: :any,                 arm64_sonoma:  "f8abfac605da31942b0d024af1c6782962e90c10de0d80ab272ea0fadc671569"
    sha256 cellar: :any,                 sonoma:        "31632901dd9eac99e6c1bdb0c1235cf0897c44b49e2b8d4f3307df27a15fc49e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99b6fd3d3bf4d86a845181d4ef26143810b1b501f34ad3809e28792c64a16a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c17638192d58902ecb8a883b99a73b3603fcbeadc219bfc436af2a0f0c70cdff"
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
