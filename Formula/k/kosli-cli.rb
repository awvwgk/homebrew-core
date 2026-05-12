class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "dbce9c99cf46971978ebe24e4bce4024b41e64832960091c53f94360ba6d3320"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8963f1221f7c4d3487c9598cdf7da9de8635bac7761c3b2a9db25c6d4618722f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "077edd8774009d462cd39d11d8a2680aea5e3daae3af6a50dd68bac647049488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f49bbbc12f3ca8459cecd01436785e33e26f3ebb251cd7d59e4d2c07253fe5b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc0449a0df4553911fd979fcf8bfc24de237cf13df4f2d1c6729cb7cbb087f07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b285c311c7410defbd68697d58fb430c135ea5889b5c25f234dd56739ddbbe0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f4ffd957da9475e84a1c1db09c7706ef7b0be4bcb62e5aa0fe80f17a637879d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
