class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.13.tgz"
  sha256 "73c6a96bac36d0b954b48902bbdcde030c25dd687e6a4e5048d1460425b15775"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a5234d416dcf3f516bbcae4d10f0a76c42b46a99f8f05457c3741f65f4a3ea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e50f211acb0a77f6add8857a6fa5e9d6247c05fdd8dd489a79d5efd14ec4bff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e50f211acb0a77f6add8857a6fa5e9d6247c05fdd8dd489a79d5efd14ec4bff"
    sha256 cellar: :any_skip_relocation, sonoma:        "76568886338075dfc3419638ad5fb59a304ee0765cfb628b7afd90a627279ee4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fee19a074bc711858e998af77d8c3dd26d6a400f0b213fc51547b8c35ddc84c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fee19a074bc711858e998af77d8c3dd26d6a400f0b213fc51547b8c35ddc84c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@playwright/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playwright-cli --version")
    assert_match "no browsers", shell_output("#{bin}/playwright-cli list")
  end
end
