class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.87.0.tgz"
  sha256 "dfc470dbb92b9d025a4c92645fb028fd1c6df893448c4e9178f084703781e86f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d91016043f4307faf1611bc863c1810f18a02f5fe9a3b6801a49bae6f26059e1"
    sha256 cellar: :any,                 arm64_sequoia: "f9a35bb715bc2f41e7c789ab9ed97cb843254964723ed3344087583f6aaade6f"
    sha256 cellar: :any,                 arm64_sonoma:  "f9a35bb715bc2f41e7c789ab9ed97cb843254964723ed3344087583f6aaade6f"
    sha256 cellar: :any,                 sonoma:        "ba0b27211bce1a5c9ecbc1cf471ef7c5230a04df571acec171f5073a5803d01e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d4373d09ee81ec6650f24b86844354d50d3444ba16f46e9d6d6758549d02047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1475aa8a6023ed5ffb86d99a45aadb13236f7177e9bef6c6cb1fbcddc088b02b"
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
