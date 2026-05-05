class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.12.0.tgz"
  sha256 "9a26c41a5dd8b9b4f0b61b876dbee1f38a0d6124a4f8a5b7ca7a44a44bec6f17"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44b5c19026152bc4d97d0b3d047c40d56ffba17dd4fe25e65068fe1c16bab29a"
    sha256 cellar: :any,                 arm64_sequoia: "acde40e9a330d2d2687def156764855e073e1625769350029b61c4f08eae13a9"
    sha256 cellar: :any,                 arm64_sonoma:  "acde40e9a330d2d2687def156764855e073e1625769350029b61c4f08eae13a9"
    sha256 cellar: :any,                 sonoma:        "9fd3d70c01c27f1e4e1d33b21bdd2ec7d45ec833d2c99fb0ab8183f273082b4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7639f71d36417f0df19213bc296c49a7fd062a8876aa74693163e27bcf558cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38953e0336e0850d62789e27cb2347c37413f60a9cd976b99a67a84b3db9cc34"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
