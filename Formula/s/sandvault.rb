class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "ba5cde2a5305c01710752181bc6e25944056f2bca4780705016367f64537cc86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dacac9aa178d413d2da1c1946bf9768eaae841c2da42a16e588ea412c8885dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dacac9aa178d413d2da1c1946bf9768eaae841c2da42a16e588ea412c8885dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dacac9aa178d413d2da1c1946bf9768eaae841c2da42a16e588ea412c8885dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcf41d9c853079864f1adf1559117dbc4753ee5323fec66e86425c327d5f4a33"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv", "sv-clone"
    bin.write_exec_script prefix/"sv", prefix/"sv-clone"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
