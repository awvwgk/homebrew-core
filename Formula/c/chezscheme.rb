class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https://cisco.github.io/ChezScheme/"
  url "https://github.com/cisco/ChezScheme/releases/download/v10.4.1/csv10.4.1.tar.gz"
  sha256 "2e74952db7bc177f0c3602e2217a341ba677d733eec4cd7726418c3a4e1ef308"
  license "Apache-2.0"
  compatibility_version 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c66451fe4748a16134e91c9a61eb20b62b713f46ac09e1fc99f7209b1b3527fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc6ac8ed634ae66aa50fbd6b110293bc9a66d4fee27c349d6a63b845fe8e2435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "297e1cacde1ee31eea4cb60e1a63b5060904a780f44a38c209d725e6334e583a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d754bf522b204abafc35b18b4fa91c304a76972e0492343436a55d4078ab1198"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b2bdf76af107c52f36245e920a326879973c50b162e916beabedfa2e0c351d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "569bf19ac38aa543d25534c4f37b6629647ace5e492f1c6b48d18fc16b49255c"
  end

  depends_on "libx11" => :build
  depends_on "xterm" => :build
  uses_from_macos "ncurses"

  def install
    inreplace "c/version.h", "/usr/X11R6", Formula["libx11"].opt_prefix
    inreplace "c/expeditor.c", "/usr/X11/bin/resize", Formula["xterm"].opt_bin/"resize"

    system "./configure",
              "--installprefix=#{prefix}",
              "--threads",
              "--installschemename=chez"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.ss").write <<~SCHEME
      (display "Hello, World!") (newline)
    SCHEME

    expected = <<~EOS
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}/chez --script hello.ss")
  end
end
