class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Terramate / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.12.2.tar.gz"
  sha256 "f95bc6a76dddc359e4ad059bdd53c5442000b8fe445d88ee45724fb3ff57ee33"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "741686931937574b25cdc2cdf11d343c26ddf39a371f2e980532697d7b410563"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "741686931937574b25cdc2cdf11d343c26ddf39a371f2e980532697d7b410563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "741686931937574b25cdc2cdf11d343c26ddf39a371f2e980532697d7b410563"
    sha256 cellar: :any_skip_relocation, sonoma:        "9427d5a9fa8a7a8b85a1dcef36da27ac9e483ccf075936f5138cfdb6772bb924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38da3f0b199e19bf8595c9da45a88cf1a0f4060b4079e58a480005ca65746ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c885de8f51d0cfb905db56a94502cdb43e2637bcdfd033d7f4d4ecc8fc58becd"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "terramate", because: "both install terramate binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt terramate tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", shell_parameter_format: :cobra)
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
