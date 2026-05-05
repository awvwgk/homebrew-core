class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v8.0.3/deployer.phar"
  sha256 "ef0e16542439cc0ad718f74dd76fc7d026ee2ed55594805d6cfd99188985a5a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "273415397bd5d9902c44ba1d456a34876dbd3c8b636640956bb888a77e004a03"
  end

  depends_on "php"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system bin/"dep", "init", "--no-interaction"
    assert_path_exists testpath/"deploy.php"
  end
end
