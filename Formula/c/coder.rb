class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.32.1.tar.gz"
  sha256 "5161fc10092e139ea5622ccdd554cffaf1e25b86641a57e467172ee311aeb6a6"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b16fe77484d20ba254eeab418ad0280fa682b190342558372900c493b0b1ddc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7f8a498a72e91bb6fe3d04cc2c5c34a9e65979180e753fc2a6c374f90fdfd63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad31a38019ef650e1e15f3f3f225721249b2b3d63cb2c641c913086cef3c9189"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc4bb4f5ce1d33a28d355c737e7cb3c0074453046f8c9fa4c5c8eaf1f411ffae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6641d6cb2133011f1387bec6362eab1673c66bb85cf7fb71a990ee8057adfd80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc38b5978ac93596702d55163ef6d69a56dbc89ae286c50b05a1284c2d6e239b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
