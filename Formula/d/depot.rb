class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.59.tar.gz"
  sha256 "29be5611e82a1060d1e775a80bd15d8c533735ff3280964d8df9ae034a09ac54"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12d6c95495e2b030ea98f43bb5aa454e42f8b89269cc587432a0f11dfa0fdaa6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12d6c95495e2b030ea98f43bb5aa454e42f8b89269cc587432a0f11dfa0fdaa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12d6c95495e2b030ea98f43bb5aa454e42f8b89269cc587432a0f11dfa0fdaa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbf718d87e576383c736c2a96fd3ef78b6b020a4c50270d861580aa78b1d73ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08826f96475dfc4c78b7e5dbaa221a53930a6c14cb542468295266307d547dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab186b19b1b2e603cb5a5d25a8e30858e098280434837dbca2e684c260918bf0"
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
