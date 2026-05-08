class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.56.1.tar.gz"
  sha256 "ddbb76df8728780e0fdf7676da2423290b315026b2c284ee11e68ea1c18a57f7"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e161ac0ab415e53d31a338b2e7408a20144ecdc1568441c3e45d495ea5260fd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03a69fef7596c7b769584fa923513d3c3f3c4e267f079da5f6c9ddcb5882e742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6bc8e503dc2bc3b1c0bee3fd3e539c388c73021f3925eb997e52f2229e23952"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bc3a25e30d1885162077e31e3baa23529284d7dbad52d8b269a2f3c614ab6aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9d85ee6881eb72da317c9ff540e72d71bd9ed3e9104ff02d35b7a2b7c9a5584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3886f8199e09562685ef06b26041d16107d9b560330b882064ff9b69e7dbab5e"
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
