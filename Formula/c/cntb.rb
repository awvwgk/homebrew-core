class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "96e27d941179c3214e4198a8aeaa43ba7fe27882ea7aa4590bc9b430f3513375"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "375ad153b7cbbc554d3acdf0881d8f9cf3c8e65128479253b3200e591521578b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "375ad153b7cbbc554d3acdf0881d8f9cf3c8e65128479253b3200e591521578b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "375ad153b7cbbc554d3acdf0881d8f9cf3c8e65128479253b3200e591521578b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d26ef49f5d1b16eef6e6946ceecdb449acd084ff390a2390138de3a52463d0d9"
    sha256 cellar: :any_skip_relocation, ventura:       "d26ef49f5d1b16eef6e6946ceecdb449acd084ff390a2390138de3a52463d0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3fa1a2d2d2696aad88f9304b1b6ab54fcfb4b1f13a069cfa516e02bd2746792"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.com/cli/cntb/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cntb", "completion")
  end

  test do
    # version command should work
    assert_match "cntb #{version}", shell_output("#{bin}/cntb version")
    # authentication shouldn't work with invalid credentials
    out = shell_output("#{bin}/cntb get instances --oauth2-user=invalid \
    --oauth2-password=invalid --oauth2-clientid=invalid \
    --oauth2-client-secret=invalid \
    --oauth2-tokenurl=https://example.com 2>&1", 1)
    assert_match 'level=fatal msg="Could not get access token due to an error', out
  end
end
