class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.7.0.tgz"
  sha256 "7a750d48eb89866a0948057f88077b3e6743e7559500c89679cfd9ac68277f40"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61c2fcf3672755f2ba43acb1008e2970f35340e24e9f51e392f8b069fa566c59"
    sha256 cellar: :any,                 arm64_sequoia: "4535563825028d77deb863a6a8807f55047a19a3ff2f77554cfadfacbda9f2a5"
    sha256 cellar: :any,                 arm64_sonoma:  "4535563825028d77deb863a6a8807f55047a19a3ff2f77554cfadfacbda9f2a5"
    sha256 cellar: :any,                 sonoma:        "5fa61822f5b2eebdf851d12c42f4953177a196d74677c4b8538942a139ff7284"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21a09eb4261088fb32a102a9bcb217d9cf00117e790e404e9dacddb5011c683d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fab389312f6e8934879c20f9b2eee5f11bc3dbdc6d102fb7569f54e0e4bb21e1"
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
