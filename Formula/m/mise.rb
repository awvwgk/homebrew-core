class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.5.2.tar.gz"
  sha256 "6a43c8b4688656fddb0024f6850b7eda419a61468a473b5b2c8eb3b5867ef9f3"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16d9a6ce2e2ecffa0937331b626f42c669cadddd528f18d8074480253955323b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b329f640a43352ffb4f943202b275982a7a1d42b3a7ceb0f97ef77cc3b96a996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a4fd18e7a76b78b10a2653bda3af79b5dd3e6ec39960069c52a69178397accb"
    sha256 cellar: :any_skip_relocation, sonoma:        "79d6b62fc35a1aee67b1361f89edaa99852626cbe3b043274ae8cddcfe07c840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7610fcebef7522377a802a38a6414823dcd4fdd0fe6137cf1f599bcb9393e870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdd290c1dda53bbc3e862b4d6f813d3f31a4b0464f3d563ee996e3fc4fe5fcd7"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish/vendor_conf.d/mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
