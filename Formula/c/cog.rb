class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.15.7.tar.gz"
  sha256 "688e2cd187924bea1ec7efdd3c9074faa62f4f803526a56f41118def5f8c50ec"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdb94f69060a75064df51b3b9f28a7454e4d12f11f9870a835ca37b1fc4099ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdb94f69060a75064df51b3b9f28a7454e4d12f11f9870a835ca37b1fc4099ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cdb94f69060a75064df51b3b9f28a7454e4d12f11f9870a835ca37b1fc4099ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "434ac0a126916a4d0a54b6e224e04a04d7ec7648a0046c971b547ecb63326556"
    sha256 cellar: :any_skip_relocation, ventura:       "434ac0a126916a4d0a54b6e224e04a04d7ec7648a0046c971b547ecb63326556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35af3fdf64279d6ac0d624b70d183765d19b65db1df4c7add8e90710f48f1544"
  end

  depends_on "go" => :build
  depends_on "python@3.13" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def python3
    "python3.13"
  end

  def install
    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath/"pkg/dockerfile/embed").install buildpath.glob("cog-*.whl").first

    ldflags = %W[
      -s -w
      -X github.com/replicate/cog/pkg/global.Version=#{version}
      -X github.com/replicate/cog/pkg/global.Commit=#{tap.user}
      -X github.com/replicate/cog/pkg/global.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cog"

    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end
