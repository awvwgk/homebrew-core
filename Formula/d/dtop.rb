class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "517848c2e8fa084767b338298805b45df1a63389774d0c17f10183598279ee6e"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2ae50f3325cb76dcb15a0cf414478b27c4785f017c1062d9faecfad2f9cd0d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0304bca896b9ebefd2470b52854e33c7e5aa95fa92c96c078488d29e9d92ae98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6695d2e662179ae2c84a5c76de34cae531d6fe1082d4a96853c88ea84af96191"
    sha256 cellar: :any_skip_relocation, sonoma:        "a198f36fd97674ad628863ae828592a1b4db88deb31e995225efb9c64e689d03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00758fe4943f0c3314bd04f3bf8888a594ea833ed60e1ed06c99b3665ae3f5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2d0995b3ed177ba87899f836b1e7f71789f8871f71089139948db7e4aa6226c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
