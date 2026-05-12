class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "453efba56358afbd3618002ea2b79826f8f5a923ad36a054c0b30c238fe9d44d"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9fdf47609cca95c04b4aed08aea2c9da5de73216f9e6062e66abe3a5c860aaf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9fdf47609cca95c04b4aed08aea2c9da5de73216f9e6062e66abe3a5c860aaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9fdf47609cca95c04b4aed08aea2c9da5de73216f9e6062e66abe3a5c860aaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "30214c39c344fc2a88bf596eb51fb935a39757df6e907c7af38a4a97ce3300c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c021ac283c70095741be720317565a04a3b1d2e028cc92d94b629a805d81d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98ffa7a06b0283f1a0ee4f7481fa1124430854fe23d4159b33c384d619607ce1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1
    )
    assert_match "No account exists with the provided key", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
