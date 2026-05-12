class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.16.0.tgz"
  sha256 "dddc2ee30238756348313ed245800ecb03597f5eb8a5ec335f6e497f0abb3da3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce2404ae351710d39f6d96ce0df032ff11e08ea1dcdb024a2f1d9ca1eb9bd284"
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
