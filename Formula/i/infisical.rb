class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.80.tar.gz"
  sha256 "a18fdbaff77564e433611d0c0f699999c085b33bef4f540e10a09de57dd99e48"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c520da34b1a3e9588bb15520e25c9cc5f6d50ad1814635c592eeab5b880695c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c520da34b1a3e9588bb15520e25c9cc5f6d50ad1814635c592eeab5b880695c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c520da34b1a3e9588bb15520e25c9cc5f6d50ad1814635c592eeab5b880695c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "50a2ab6d60ffa7138e6824a3f04e70ac0ce7479029af4c13f7d7ba6254856dbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2e4a469c592c0ac66142d96dabd363bd425d0c40613264f2c28c7542c3fa8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d358a0a5c21c04832b79bb90e2fa670554bd1fa096cb052a4638c327f0ef57bf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end
