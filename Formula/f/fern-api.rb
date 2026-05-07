class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.19.0.tgz"
  sha256 "ea022a4ddd2469fffcc30390dccbb8ef88d68495967ee47373d11b72cdcbaf0c"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5759928c0c026e030168dbd77dbf410c09e37cbdb9797e538ccc9a8c19de147f"
    sha256 cellar: :any,                 arm64_sequoia: "f5171dcc31e58d7ab331de7f068ce751382e6f767e91e609db1c1bcc71919fe5"
    sha256 cellar: :any,                 arm64_sonoma:  "f5171dcc31e58d7ab331de7f068ce751382e6f767e91e609db1c1bcc71919fe5"
    sha256 cellar: :any,                 sonoma:        "4589c4eef45fdc0fa0b064f046aad58026ec80ff26c5fb4e07a697dd48d3eae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17f66d6de932e8db055234707c8603ed10aaf73b7a4e19d94df608046160c23e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "378632891ad31d43085c05b52ac2be61be7dbdbdc538846c3a09a04460ccb516"
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
