class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.10.tgz"
  sha256 "76af87642a62fcb9bc35dd161f3231491ae47e113d0bce970a5b39ff2a8bdd47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ffaf67eba7048a76b387f1f45b633aba972f4a7bcd9f4ab39b21749cafffe2b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
