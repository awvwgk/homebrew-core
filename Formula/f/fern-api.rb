class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.24.0.tgz"
  sha256 "642349c724f22aea7d8e09ffbbbea8582cb0c3c72781176006331dabef86abc7"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d97ce8f9b7ea3055ffb9d854202249daca3251d63c504c26a4d64d2f86a83fc6"
    sha256 cellar: :any,                 arm64_sequoia: "7e922ef626b178603f3073668dc593c52fd49cc117c4582ab178627a64746581"
    sha256 cellar: :any,                 arm64_sonoma:  "7e922ef626b178603f3073668dc593c52fd49cc117c4582ab178627a64746581"
    sha256 cellar: :any,                 sonoma:        "6d222d8e5e1122a0a437ebbcfaed33995ea2050e063a70ba673e977aa394549a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cda0e94dd9ff641163af5b776879fd476496c679224eedabcfc2dec37fa9445d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cce077b35317b4826002ae78c0e358a1123a60cecd25fa0c546baa036c67cf7"
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
