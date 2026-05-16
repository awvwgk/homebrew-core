class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-21.0.0.tgz"
  sha256 "863f7f768f0a137503e164f6bfcfd9329ac041272d825d60cfb5944c58e41d74"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b30ad3353372398e2363b7edbb94c17b2a0f779ae7e80aabef740263893ba370"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bfb5dbdca23c8750d4d527d0fa184d48c4d0cd582e445ceec4c8d6e85699f85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bfb5dbdca23c8750d4d527d0fa184d48c4d0cd582e445ceec4c8d6e85699f85"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e779e40806f172cacabc0304c55936feed7c4656270906b9cf8d2e192693519"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7692715b0c23a29b6444285019b18adf230021b5d536c214896e4010f36ea6d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7692715b0c23a29b6444285019b18adf230021b5d536c214896e4010f36ea6d1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
