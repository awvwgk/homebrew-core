class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://github.com/moonrepo/proto/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "61009f6da360159eea4757c828f5615000ec7cb3f551bb59935b3c4dfc0a697a"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37b003bb38900f1a4fdca3fcce12110f85e70d7b0177e628ebf2fd27fbd8746e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26357761a6715c154d825b85ca17166cd812577c92e32fa2ff85bd9532690cc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f686f7b1fea71dc4bd4859777df448daa35b0716b229dccb55d261f25c5c9648"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1a46fbc089cf292c7b8e50670aed1fa6062cc0dfd39878819d843e87858c9bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef47935dbb594c6cfdce34a51494001632641d9af59b38f73fdf4886ffb33b36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de74008edf284173e2e7ab24a2add1a111ae73f4fbf244e99de0113bcb42e6b5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    node_version = "24.15.0"
    system bin/"proto", "install", "node", node_version
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match node_version, shell_output("#{node} --version")

    (testpath/"test.js").write <<~JS
      console.log('hello');
    JS
    assert_equal "hello", shell_output("#{node} #{testpath}/test.js").chomp
  end
end
