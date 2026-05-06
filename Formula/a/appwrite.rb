class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-20.1.0.tgz"
  sha256 "92fe957e22b9497b7bd354ad3dd2d6c8b145185f6124aeacd20a5d6e502b5a57"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a576fae46c2a6c0016c3b5576596e5529cb58039f06688f9ff6a3421db560e96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3e1b14c33a7c5a11e43b880822c0e88abb7d845f72fc54c5f24ffa3b859aa89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3e1b14c33a7c5a11e43b880822c0e88abb7d845f72fc54c5f24ffa3b859aa89"
    sha256 cellar: :any_skip_relocation, sonoma:        "338704e1c67f53c42ebf535b5cbf45be0dfee4280f3fce1aefc3ed6e33679f38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91cea09e2a945e1c36ab31c3b1e0eddd3ea21961742fa9d8ccf6e4e6869914e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91cea09e2a945e1c36ab31c3b1e0eddd3ea21961742fa9d8ccf6e4e6869914e5"
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
