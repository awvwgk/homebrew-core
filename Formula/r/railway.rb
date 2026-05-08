class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.54.0.tar.gz"
  sha256 "f621b8e003f86649e81d1377580afa99e4a3c2b45cfbcaa7893732bd487797e4"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8568a06ec30713cd9c9576ce6687a20e41292738f82df334233ab1cfaaa0172e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19225130ca90b945f636eb061dc8ae2567763f642b8934a08c023e067560f8fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce0c9b88b936d76deca23a089a68cac2b4fd71132ecc5422ea4724badcdbc7be"
    sha256 cellar: :any_skip_relocation, sonoma:        "718784fb19e6ad6e61205ca98c85bde36de87af87b92857e510d78805d245a84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f24ad7dfa20ac897933f3898b95fc8d90ffe44eb8b1d29a1ad3bc4fc3ec95ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "078bd72f194362c4cbaa51cb864357748986a7c3485f511c78ff4efbfcf902aa"
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
