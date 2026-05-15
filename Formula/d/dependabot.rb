class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.86.0.tar.gz"
  sha256 "6a50c46a184db0322c4a9e3797c7a365f3d09e719fa8cb49d0291e2516c8a18b"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c9364b5feeaa488e180b566c286e24d50cae51c7a1786994c55c141efbc884b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9364b5feeaa488e180b566c286e24d50cae51c7a1786994c55c141efbc884b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c9364b5feeaa488e180b566c286e24d50cae51c7a1786994c55c141efbc884b"
    sha256 cellar: :any_skip_relocation, sonoma:        "eefee78629692bdbe6f102df19f63e51fd40f5393e69299e8f6a956ad20e7f62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb934486266772ff9c8ed455458cdf4cf4fcab02fcbcc882442f4d0e36e9a98e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcd8d577fffae755e529c147f0764458362a644880fd7b76992add6046545d33"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
