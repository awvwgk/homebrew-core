class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://github.com/openshift/osdctl/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "e937eacc5310940b652db3ba68c38ec2743c923a41bd9fdf9117d645201cb3fd"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd7dd46f8504b3c0f3882aa2a5bd057c82e99582acf62495b71f7e191aa6db22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd7dd46f8504b3c0f3882aa2a5bd057c82e99582acf62495b71f7e191aa6db22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd7dd46f8504b3c0f3882aa2a5bd057c82e99582acf62495b71f7e191aa6db22"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7727e363f2a5f7bf369cbfc7ada0316b3f706f251b3fbcdb9e4b6302b80672d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34776732d5e333a9314953ef1c38e0ac1f42ed9a4505a16b5a3bd699aa033abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6b29d7ff4f256ab1cd3449bdff104b4fd939d6b1cff03b1bb18601954f7506b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOFLAGS"] = "-mod=readonly"

    ldflags = %W[
      -s -w
      -X github.com/openshift/osdctl/pkg/utils.Version=#{version}
      -X github.com/openshift/osdctl/pkg/utils.InstallMethod=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"osdctl", "--skip-version-check", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osdctl version")

    assert_match 'Error: required flag(s) "cluster-id" not set',
      shell_output("#{bin}/osdctl --skip-version-check cluster context 2>&1", 1)
  end
end
