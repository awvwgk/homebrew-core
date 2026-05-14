class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-3.0.0.tgz"
  sha256 "3fc5758453a3c7d7647b08984e92676349f88708cd593232728694b349ab8dee"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "d053568917c056c8c3a8937e58f0b5f2688d40b7c16fe2f8ea53b97d537a8203"
    sha256                               arm64_sequoia: "d053568917c056c8c3a8937e58f0b5f2688d40b7c16fe2f8ea53b97d537a8203"
    sha256                               arm64_sonoma:  "d053568917c056c8c3a8937e58f0b5f2688d40b7c16fe2f8ea53b97d537a8203"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff35da4dacfdcdde0f9983ec4a6c47aacd01915b6b839d536499015e8f11c903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea26df0f447cb2cec9c5a34cab606a93c4e910579dd9062e70e1ec3ddb547e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd33a6099ae247ddd66fe9c91abdf659e93d90d21de1355b34e5b8936631967a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Unauthorized", shell_output("#{bin}/cline task --json --plan 'Hello World!'", 1)
  end
end
