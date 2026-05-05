class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.14.0.tar.gz"
  sha256 "df716e7afcf439461c330956c8c4bd8be3b17179f2bff702609d06a419e6bbbb"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94c1cf5a384ed5e9e72c423b2dc1784c3c1cfd914ee2f0e89cd10fdfbaee51c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d8673fc7f314ea2a4b67710c6a29e854ed4ccf65e92265e4853181364fafdcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cde0d7cbd23c6abab09ce6ec09905eb275cde0eb08d9f3499d3e763699dfe7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a6782847fa15041faa98b98059b6302ebb388cd32d954e756092ae5bc6d4a29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ecbaf9c6b0521f1517c75282b01afb808c3ba6b25539a3a809dab7c33676f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c61481281b50f15e191e86d7ef99d13d4bc7ae1c3eb75a65d04eca7da2e643f"
  end

  depends_on "just" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "python"

  def install
    system "just", "install", "pay", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "No pay account configured"
    assert_match expected, shell_output("#{bin}/pay --no-dna fetch https://httpbin.org/status/402 2>&1", 1)
  end
end
