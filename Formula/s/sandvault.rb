class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "694e2cf6973c58756052d3176a7ecc90949642d27b81c4f2c5ea0cb5fbd39e4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d51c2e856a4a33732ca5d11c0f57abf39ed6fd68b8db5f6d798a3aaf9f417eb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d51c2e856a4a33732ca5d11c0f57abf39ed6fd68b8db5f6d798a3aaf9f417eb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d51c2e856a4a33732ca5d11c0f57abf39ed6fd68b8db5f6d798a3aaf9f417eb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "14c00bd0d218d96d9eeab2ee082c5b27b401ff64e1656264f291504a984dc4bb"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
