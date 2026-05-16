class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.1.6.tgz"
  sha256 "d03d0e824230a6a81fdc9c22ffafe09cb93577b6c40be810d8383f013a7d61c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38740db2389d572b0d7e921c5a565c8e48082555e369a5f5a68962c5e2e08fb2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/haraka --version")

    system bin/"haraka", "--install", testpath/"config"
    assert_path_exists testpath/"config/README"

    output = shell_output("#{bin}/haraka --list")
    assert_match "plugins/auth", output
  end
end
