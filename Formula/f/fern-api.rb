class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.16.0.tgz"
  sha256 "3f2ae9af2af389de1c71271c48b4b09fd9d9b295d47b1a0879779c1dbeb0acb7"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b12f509c2af197cb0980a72806e4070a29860a8ad72de6bc6506c0f4b3ac30ce"
    sha256 cellar: :any,                 arm64_sequoia: "f18cb1794b335cf22cba506e2dd29521ce1689accb059a447078a1a3bc9d65ea"
    sha256 cellar: :any,                 arm64_sonoma:  "f18cb1794b335cf22cba506e2dd29521ce1689accb059a447078a1a3bc9d65ea"
    sha256 cellar: :any,                 sonoma:        "187584256301b23d5a7345b05cad0e257435495b621d21c3279e2b803a5a9430"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ac4c639caa5e77b62b46c6dacbcb0510315b5bbabc8ddc5dfadee8170ad7363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5403b6e704722956b2eaeffded47b47a4417d05b8b573e5d2c3f9bee3f46825a"
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
