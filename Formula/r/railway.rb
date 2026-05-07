class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.51.0.tar.gz"
  sha256 "82c60e9164cf74e3971af7530e51c348fc5819ae253ec89678275a89d18a2f48"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d9cf0c2047cf8b79ba3e64762a6c49b03203e8db7f9753d2073c515e6aa8904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4d66b08f0bce1ff981fb55b1c00d8991fb03b578a8ef234284fa5cebb997db3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c522b1d1165d5cb412a04105d87b0782d19dda572bec7c6f7630bc450f3d7389"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6a0a94ff152891c95f80cf1b2db02de9ffc26df4be8a822e2c87302abd08d94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "008b1dc7860ff07af2de220d510191f024ae32328c9969d12e39312fb7c319bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0c810cb2bb6abd7838596e334aec8a1967a5ad2c955c6219e8227cc4c6e8986"
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
