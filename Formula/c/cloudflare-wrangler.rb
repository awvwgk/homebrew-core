class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.20.2.tgz"
  sha256 "c5c481765a0c6aa50058ef99f261ac349d46b0410dfe56847077a6ded51f949f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "13aed39bc7e2124cd57a44c1f34804a5b59ee035db19db87a5561a9c32e4dd46"
    sha256 cellar: :any,                 arm64_sonoma:  "13aed39bc7e2124cd57a44c1f34804a5b59ee035db19db87a5561a9c32e4dd46"
    sha256 cellar: :any,                 arm64_ventura: "13aed39bc7e2124cd57a44c1f34804a5b59ee035db19db87a5561a9c32e4dd46"
    sha256                               sonoma:        "f077144e00ef1e8e14b03c6e4a9ffb20e48897ea5a2be75db58587bd07f3fe75"
    sha256                               ventura:       "f077144e00ef1e8e14b03c6e4a9ffb20e48897ea5a2be75db58587bd07f3fe75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd54ab04be1210dd23edb468e2421ef0ba08b388f9b30f569bfb40f5edd37bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2601a7da0066f01f06ee2cd9587faf0dead6824a1a0dee313592337819e64cfd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
