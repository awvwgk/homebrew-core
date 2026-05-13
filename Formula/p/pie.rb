class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://github.com/php/pie/releases/download/1.4.4/pie.phar"
  sha256 "ab2810068b4b4b42aa35448463644ed0d1e74c99828746a0d05409f0433164c3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da0d51933999345faa0c92a0da3a36961acf011e3ddbccbb3b37f1b7a9c26fe9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da0d51933999345faa0c92a0da3a36961acf011e3ddbccbb3b37f1b7a9c26fe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da0d51933999345faa0c92a0da3a36961acf011e3ddbccbb3b37f1b7a9c26fe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e5d8b6f6fb55d66578ecb401c940027bfbbf47871bfa747558c7243bf0f6e9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e5d8b6f6fb55d66578ecb401c940027bfbbf47871bfa747558c7243bf0f6e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e5d8b6f6fb55d66578ecb401c940027bfbbf47871bfa747558c7243bf0f6e9a"
  end

  depends_on "pkgconf" => :test
  depends_on "re2c" => :test
  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
