class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://github.com/openshift/osdctl/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "44a2e11b05d5474e9fc3b1c20c49613f4200a7539bd0d05d8484ac74a7a51b48"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d2ab426fc25c0d69ad469fe8485567d6d41cfcbcf73e3a0c2401b57bcb3e5b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d2ab426fc25c0d69ad469fe8485567d6d41cfcbcf73e3a0c2401b57bcb3e5b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d2ab426fc25c0d69ad469fe8485567d6d41cfcbcf73e3a0c2401b57bcb3e5b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f4c2c818a59ed0276462864310b178326270859a5fa4c7e775e63eeb51f19c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e5a6b6d9c51c37b6c9aebcce69f289e09d279231b5f9cf93d9925ffa5f3a065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ed5817d8f29bbe34a824f6f71417de46c9e517848e48f7e28b52141a99dbf7"
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
