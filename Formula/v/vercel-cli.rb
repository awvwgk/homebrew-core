class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-53.1.0.tgz"
  sha256 "509b03c2cf934c9cb2236e29f72c72d33d4ee97138da9e5fdda7a9f5f8a0a5df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd8393d8dc298e2714eaec4479b0fd8fd87ee7b0db491c750558eda9e41317a6"
    sha256 cellar: :any,                 arm64_sequoia: "91293b124f01debf73106d64f819f71d6fa0aa6aeef436ff09ae91758de2a0ce"
    sha256 cellar: :any,                 arm64_sonoma:  "91293b124f01debf73106d64f819f71d6fa0aa6aeef436ff09ae91758de2a0ce"
    sha256 cellar: :any,                 sonoma:        "03bd9891d977f6c4a3db8ba69f0fe4383f02831e29f93a8d0801c570fdaeb880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07352f594492489926dbaf4abf4cbc98ae85a831a79df8eeb1adc8551d1c5e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8a92623a1e9a68959b4c501170f1bf52b2df3c851a3753680c5730f07e6ff8f"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "await getUpdateCommand()",
                               '"brew upgrade vercel-cli"'

    system "npm", "install", *std_npm_args
    node_modules = libexec/"lib/node_modules/vercel/node_modules"

    rm_r node_modules/"sandbox/dist/pty-server-linux-x86_64"

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
