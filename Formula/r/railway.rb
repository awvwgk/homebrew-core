class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.48.0.tar.gz"
  sha256 "3abb32cd445b9645407c48b8dfa869e119db572228a0cb4e3146c728f3c926df"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1559984f1efd246b745bfa5e078419a416d38fc4762c8e0f50a25eecd0e14ccd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f936cfe98e1759048fc73978ac771b2753ac5bb4688bdc1eb5246ec22400f00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a56c3adb22e8fc51d54a6fd0c9a52c5602c437f40df227cf142bcbafd6ee5fd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a6792024b366b060a57d97128e1275656d267f1a624fb7466b0eed6d237f0fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ffd6d21b2222c672adbd29d0f630b80545ef7c4070163b8a7c1206571e4a517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f80101a294bced68b1870dd4e72fa81557a2717889bf814ec3617b1cfc13760"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
