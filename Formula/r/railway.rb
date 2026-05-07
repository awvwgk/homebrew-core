class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.50.0.tar.gz"
  sha256 "e6a8b2e612166fc9222a4c6cf32923792b67960a43f6d8a4d5905cefa57236d3"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a5139ad91a61407d784158a953995ce7468c6c5eee5c204d924b995225c7865"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ede43d3a8b7396fdb302bdae23122c8f9ac95388165249a1360d3a0eba8b2c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9474c47cf17a0a4bc9dcb6615789d910c0f3d78074819e28fdc61a5dc358e0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f737517593cc6377e850d2d2f93c43ee57d1b3d434a8d2943bde9b5ed966a7f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c654816db34fc16b5c2c8eefb03a552294aaee09db1f5f83e65b84646427af4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be90efa2e10b1dead911e946bd7cbc05d449982a51cc428c25acf0139359176f"
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
