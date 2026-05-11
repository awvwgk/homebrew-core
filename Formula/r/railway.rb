class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.57.4.tar.gz"
  sha256 "30e3873c7643283e54d6f1e2803680af6f270d6e4a5d572a3bb11290fb1fe4d6"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dec0d4e263535d953f5a67f76403693032c069ded4e5b64c6ba7c7bfc82ab60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f72f1091bc763716f78c7f0a29eb7c270d6f7e46b1c16934ac2ebefb8a6a5638"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f612df694d6cebaf3a31f6de17c41b56652edc6d026affa42060ad329037360"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecab70e3ee89343ce28b3489403a771e994eb90c03a49bb8fb1ef460cd5c455e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68f640bbb1c835fb3e503af0096d3e7002be511a3d34f6ca5e887b0e4ebb1dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3a20d122e40601e973f705c20ca0286db7b667b8ee7efa13eeb1a277cd419bd"
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
