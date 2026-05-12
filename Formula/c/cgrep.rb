class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://awgn.github.io/cgrep/"
  url "https://hackage.haskell.org/package/cgrep-9.2.3/cgrep-9.2.3.tar.gz"
  sha256 "80119410ad24c668e4668773e21ac50439051bdf12d61668995a7cf652304691"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "795110cada7d19070299e6b5211926ee56f93cd99a0ea953f864b2d38e5d1baf"
    sha256 cellar: :any,                 arm64_sequoia: "39c2a15d072a5f0bc7626cb4c1b8a3d0df93e1c35e2758cdb132ccdf6f1ef333"
    sha256 cellar: :any,                 arm64_sonoma:  "3a1e32e1ee9f3731d9f5d841c8a0287640786c289e9cbf08883789caf504bf6a"
    sha256 cellar: :any,                 sonoma:        "6da4b0ad3a258ea6984ff2c61be7b073c860a61bf7ee60f0273ae09437989e70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70df4bf4927855676cf1040e68307563dd3efaf345333d26f95ff4231b813580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "527d18ecbc4a1958b384edaeae5592d076b982912a045a77cfe7d704eb3e31a9"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  conflicts_with "aerleon", because: "both install `cgrep` binaries"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"t.rb").write <<~RUBY
      # puts test comment.
      puts "test literal."
    RUBY

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
