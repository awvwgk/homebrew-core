class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/cli/archive/refs/tags/v0.43.84.tar.gz"
  sha256 "c051f497b71d0ef4ac9a4316f82713bb691bc7d626e11467ab170b0610fa5f9c"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a875b0718392539bfb576e6a74e7ca23c1e254f96f0b88a0df7cb8692a19526c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a875b0718392539bfb576e6a74e7ca23c1e254f96f0b88a0df7cb8692a19526c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a875b0718392539bfb576e6a74e7ca23c1e254f96f0b88a0df7cb8692a19526c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c007cfc06381c3d21c8c1f884a5e13e8b3dd10f0a8219507d9752b7a834432a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69ebbf443e3a43d4fed68c41cb895413adbc581c71380e6c524bf9ad8a0cf804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ccf04789f2a1a486a132c880e61ce5f49d23598200c2cfce8c9dc6feeebb4ad"
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
