class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-6.17.2.tgz"
  sha256 "b1f27bd6bc9dc21e369a7a571ab2a00ff496cf62a8c4c6b0b99764b8c457ad74"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b8e9da1b35546c17a1cba1b3594d60dcbdd9a3086bcc3f6c0f8f75a60b6de81"
    sha256 cellar: :any,                 arm64_sequoia: "3d9ba987ff5e1052a7c989d40c24f2530c446bef9ce89c0cb17d7ccf1fb9a68e"
    sha256 cellar: :any,                 arm64_sonoma:  "3d9ba987ff5e1052a7c989d40c24f2530c446bef9ce89c0cb17d7ccf1fb9a68e"
    sha256 cellar: :any,                 sonoma:        "330e634b02e1715b7c928e374d57bb8c22319996538d68ffee81e0878b941ed9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b15afdf4fa93c00da47d6c3676e6b6f8cf2d0f3acbc6abdf97067c55dac37200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "001b3f8002d715bd4386f2e30798694798b8a909e6b674c86e8b3416b6e1f7e1"
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
