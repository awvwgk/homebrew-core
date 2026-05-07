class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.60.tar.gz"
  sha256 "da78bc95ef4f284bbc3db2864c3b99dbafc323516e536ef4f1c78eced033b3bb"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68532213aec7ad674d20bb9fbd481f0a4eea88b29e46c1514effc7048109796a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68532213aec7ad674d20bb9fbd481f0a4eea88b29e46c1514effc7048109796a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68532213aec7ad674d20bb9fbd481f0a4eea88b29e46c1514effc7048109796a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f25f004b585d2a038786fa908574f708094ae39c909e35e8c0be9bb32361f7f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f96b716d83f70e58ff578c29449072a330d76d04ea9c895ee85802380aa9e0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f21cc4fea64e6aff7d616fdf80b4f4c7bbcc9d80260d731ab14b72f7d676ade"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end
