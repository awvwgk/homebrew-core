class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "f32b4bbcb624ac6d8b05feef5326a19797c8fce62f92e1b6f5185b8f01bc381d"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30722d9ffc716a6eb2cfd826ebe7a1c8505cd0b5f1cef89bd715ebeb9d8714b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeaee218418154c634a59bcf00b50e46240698c7d78a3f94f7de1d7e40aa1317"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dec9231b7b158cdc7b3196e43271ec747a4057e06acc5973749fb5742a48be8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f05049de0f9dc8843213b84b29b3366b094b78593a4f8e767481e47b86936027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d69ee6a1e519de8a85a71aff1594f2e0246492798521fc05bf27c5f9d37c5f91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e73b0a6eb7fb1eb0bd2b317de8626f2af307c3f45c9a5759b6e36c040f4a7e27"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end
