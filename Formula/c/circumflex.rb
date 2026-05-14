class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/4.1.1.tar.gz"
  sha256 "c5900e13c41d2e5a1da2d45e0d63b38d345dca584edfbf8e60b4daa7cda88cae"
  license "MIT"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fe95d11fac0ad5b703add2372bca7d04ab16355788c02f2ad1c96e2cb565184"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fe95d11fac0ad5b703add2372bca7d04ab16355788c02f2ad1c96e2cb565184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fe95d11fac0ad5b703add2372bca7d04ab16355788c02f2ad1c96e2cb565184"
    sha256 cellar: :any_skip_relocation, sonoma:        "30b51319f6a2fbbe9b4d4a0046d16bb53dbd033b0d13b920a1f4c29fc4312c63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0d37e7ff5744115e8761e00919540432f55eb8124583cbc2a07c01d130fedca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c9724c5d4e8d78dbdf2a4e67582d23d08067dba40898eeda52b30a5e8f09aa7"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w"), "./cmd/clx"
    man1.install "share/man/clx.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    config_home = testpath/".config"

    assert_match "Item added to favorites", shell_output("#{bin}/clx add 1")
    assert_path_exists config_home/"circumflex/favorites.json"
  end
end
