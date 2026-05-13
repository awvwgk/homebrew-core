class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.63.0.tar.gz"
  sha256 "8bf9de6c031aeca8afb85bca5aec2ee82034b339525e2862e0c1dcc6d470d9c0"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "5722afbd4eded449fa851b9bcbf5bc0a7ec4f12e26a6d571e2ed3f07c9e3d82c"
    sha256               arm64_sequoia: "62842cce8435a00584305d6d8e7f07c0bacc3f75a60a03d3d4fdfa2affd2ae72"
    sha256               arm64_sonoma:  "2d243757fc433537a84384ca603001d1435aa7c4c5128f0a81dd0dd61782f7da"
    sha256 cellar: :any, sonoma:        "81a8f74965f172de98f832a34ba59a6e7ab0e44c4a642f6f8471a0e40d6f87f2"
    sha256               arm64_linux:   "4fc65a51f0c9a4393d4ccfbfdd5059e74e822b47b27ad9f0edd9b578942bcfc8"
    sha256               x86_64_linux:  "c5b03ed649c02aed64403b5d782ea4f9bbaa103696aeea98c7c60c2ab84c09be"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "vulkan-loader" => :build
  depends_on "yyjson"

  uses_from_macos "sqlite" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "elfutils" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
    depends_on "zlib-ng-compat" => :build
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DBUILD_FLASHFETCH=OFF
      -DENABLE_SYSTEM_YYJSON=ON
    ]
    if HOMEBREW_PREFIX.to_s != HOMEBREW_DEFAULT_PREFIX
      # CMake already adds default Homebrew prefixes to rpath.
      args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"
    end
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
