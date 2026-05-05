class Fifechan < Formula
  desc "C++ GUI library designed for games"
  homepage "https://fifengine.github.io/fifechan/"
  url "https://github.com/fifengine/fifechan/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "df3cba475716346fd27f963b9b027a02a92f697466596a3cc215a2b97d543c76"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "1a4e6bb77b1d87e8b0d27ebd76e5c649d6ae8a9cf3b2701e8ccac99586c69540"
    sha256 cellar: :any,                 arm64_sequoia: "95096b9ae6dc3ecfddd7213be81e5fa0c52d10f8f2534611de6e6f8efbf0ef47"
    sha256 cellar: :any,                 arm64_sonoma:  "ab1d7c0aa1c9f1576dc1c9debb66969e450914ed00f69d4a83d55afea3fcacd0"
    sha256 cellar: :any,                 sonoma:        "626e48ecf21a329ccdfbf0a0aa86e2b10d9500df48a0ad2353410b11394057c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34fb16feb5a2d79ca14f47b7f1c685b53b260252a2ab61ad8d1a0dadc21a9700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6536748d6cdcc530a53baa0a3fb57ee9cab21225b52026f1c16fd41203585630"
  end

  depends_on "cmake" => :build
  depends_on "utf8cpp" => :build
  depends_on "allegro"
  depends_on "freetype"
  depends_on "sdl3"
  depends_on "sdl3_image"
  depends_on "sdl3_ttf"

  on_linux do
    depends_on "mesa"
  end

  def install
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DUSE_VCPKG=OFF
      -DFIFEGUI_EXAMPLES=OFF
      -DFIFEGUI_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"fifechan_test.cpp").write <<~CPP
      #include <fifechan.hpp>
      int main(int n, char** c) {
        fcn::Container* mContainer = new fcn::Container();
        if (mContainer == nullptr) {
          return 1;
        }
        return 0;
      }
    CPP

    system ENV.cxx, "fifechan_test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lfifechan", "-o", "fifechan_test"
    system "./fifechan_test"
  end
end
