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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99db0d0ab8af08266013c7a4bde09cc6c2a688ef409dec6807dd3ba1f3077b18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce647cea53047a05d5f3aca9209bab7f737a050f0739532b4e8dd3e3976a8ba4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d796cd320c8ded19fddc17124623c97fde06b3733a2841498b6b883e496a67ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "d57ebd8c03e6f31ca337a4ff86999bf4bea5b8eb607a5da9fcfdf77b6da402a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae7b1a9a96b31233e80915ad3598e7a4ce03c18244176b0f5d949718acbb0221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "253241d2ea77d6eccffd7f84d677d3690a51ff5383aaf588367c0535880e3b97"
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
