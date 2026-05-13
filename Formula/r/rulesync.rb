class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.17.0.tgz"
  sha256 "1a0b99788045f5cb3be5123b2ce068549e2afffd4bd715827f8834faad231307"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f560f74e8cb3c47ea526ac092a814245389d7a707a1d89b6027a263125b1b46"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
