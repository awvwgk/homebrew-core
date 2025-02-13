class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.3.79",
      revision: "49f10cd74407b1416e210728f0ce6491853db05a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e906777981face761d85dff8c64827bd14bb5998b498dd191b959b10e6ea60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e906777981face761d85dff8c64827bd14bb5998b498dd191b959b10e6ea60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6e906777981face761d85dff8c64827bd14bb5998b498dd191b959b10e6ea60"
    sha256 cellar: :any_skip_relocation, sonoma:        "c626c86fe62e36ca95d4a4db14b14c05978c991fb82a9cb776c54eeac65ccce5"
    sha256 cellar: :any_skip_relocation, ventura:       "c626c86fe62e36ca95d4a4db14b14c05978c991fb82a9cb776c54eeac65ccce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd075ae7af59e7d4db7eb3236e991a11b83eaf15861cf392134b50e68b32e9f2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
    generate_completions_from_executable(bin/"fly", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
