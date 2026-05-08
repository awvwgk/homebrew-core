class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.90.0.tgz"
  sha256 "ff3ef014f6f409a62ddf5d2a89d60770982ae8836fcaf1d4617b80287c4e3743"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "15732aade6aea8d7548a7cd9bb68cd80b6ea71d4a0b310a4cee885f3ec0fcac4"
    sha256 cellar: :any,                 arm64_sequoia: "338b2237893ee43ddb7005ed7f22744203279bb15df66966fd4debe123e407aa"
    sha256 cellar: :any,                 arm64_sonoma:  "338b2237893ee43ddb7005ed7f22744203279bb15df66966fd4debe123e407aa"
    sha256 cellar: :any,                 sonoma:        "740c4c12ee62540af3ebe7033e5cf691faeb46d59b1d04309722281c4e77d11b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98b920c5a6d876416efb979392dc9b484f0b5083c7bd56085c6565c20931fd16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "683bd225fcf4f08ff667231cae8763a09318a1130da14392487bf644e73eebf2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    generate_completions_from_executable(bin/"wrangler", "complete", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
