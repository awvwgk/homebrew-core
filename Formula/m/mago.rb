class Mago < Formula
  desc "Toolchain for PHP to help developers write better code"
  homepage "https://github.com/carthage-software/mago"
  url "https://github.com/carthage-software/mago/releases/download/1.27.0/source-code.tar.gz"
  sha256 "3da549f98ea5a03dc6d5b5782367922e6ffe25d5e6c2bbbec22b5107f7ccfa90"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a4614b79b18e7bb43116479efffb8dec8d7d4a86956bdeea5cd7389c0176a2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f1e5e2f7f4530f4a6d80ff972b72cd724c022c0e0eafbac81b4f7b3abf13bd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bd3480d7fc5440dea4a30638c3994ab5372c2aa06666118e942c75c153d5f0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "14d2c33f8f50ad9dc2edce681ba6c778daab100db8d221f4d3af5cb97ca4429b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81ec778d9f565b347aaed9348fc436c0a691059467fa4c275cf6e8279450e6c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c6d476eff7caeb657b80a1344f854a8930149f2a9c732def3b8d3fb624fdec3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mago --version")

    (testpath/"example.php").write("<?php echo 'Hello, Mago!';")
    output = shell_output("#{bin}/mago lint . 2>&1")
    assert_match "Missing `declare(strict_types=1);` statement at the beginning of the file", output

    (testpath/"unformatted.php").write("<?php echo 'Unformatted';?>")
    system bin/"mago", "fmt"
    assert_match "<?php echo 'Unformatted';?>", (testpath/"unformatted.php").read
  end
end
