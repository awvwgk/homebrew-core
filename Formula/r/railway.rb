class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.58.0.tar.gz"
  sha256 "a584c5f28af224b2bdfb42dbf18b9ced56d8c4047a2a2ef1be3c34824a308c65"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4eab68ab8dd3d744e8e9e396811d56e516d7ea94a22e0bddeb00680a71886935"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06a699287f1d49e2621747e82529af08b6082371e6c16c641c8977debf44e218"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20104467c27a7b82bb60edbe5ded862802b2e8fb1955a8325fa2abad27a5b09c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fcf5d79a6fc690ca268d72151697b8954f84a734282a7dc2951979ee55e2474"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b918c50035f7b9d5f3d3f65b3d174aa346a3c3e3474323be2518b1f185c3bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6108eb14f1dd18f4c5f957e16fe3131409810d047f0e6d82358f9ee7883775d"
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
