class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.25.0.tgz"
  sha256 "7d8c6ba617dd1b05b25957347afdf5a25e0a6b477c7b83d03b1943efbee7c72c"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2afca30e092348723ab061d09fabed72aee4725e2990acf802a4a500df638bb0"
    sha256 cellar: :any,                 arm64_sequoia: "533edd51b900f8b6096051ef0ce2a08e4de1d1a7d6d020a07cad9367aabec6e5"
    sha256 cellar: :any,                 arm64_sonoma:  "533edd51b900f8b6096051ef0ce2a08e4de1d1a7d6d020a07cad9367aabec6e5"
    sha256 cellar: :any,                 sonoma:        "bc17b2907d5c9210d6ec5621aa0dbe7c96dd8ab79bb38094c4760432dc077dfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e20a4d9f3a472732304ba3b974461e97380c002f70a9dbe8feaa366e7581ff66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69cac38510a0462ebf9bec5b4a3fd774986aa4be5a4fb20148051a98a4baeaff"
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
