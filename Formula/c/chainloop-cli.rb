class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.96.0.tar.gz"
  sha256 "8e1fc2cba441d6e53dcb5378edc8679872723dcdb924697b161a00bc10c0e4b3"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37dd61f5bf94ec7be1969878310ebf20257b45f53b08e860b7b992d09afbb40c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc7cf093303f50e92f6c6c1971a7ce2b8e98d95411e0b11dac05f46a640a6b58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "003884c6e3e0c050de1f988136e4ab5f60f22a39ad7b65774b788d46bb71151f"
    sha256 cellar: :any_skip_relocation, sonoma:        "84bbfb4922b1030a529ca4aaaf32d04a4065cb00faba8fec6d68eb9488b92b6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "936666bab1e0a7a51dcf65efc470f5a1ef12e8bacddb3bde71adadf062acd2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab63fe30c9b867e57d1798bab2c76b7501aa9eeedbf6865d7d9ca582430a0ef2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end
