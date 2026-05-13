class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "34a6061bbfbcc70f9af7e9732fd5588e4b1288a9d04ce1369c49dece46502e38"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4995dbd7a5b947718256e2cb4584f0416bd39bb9ef1ec61c59c482c0eeddf971"
    sha256 cellar: :any,                 arm64_sequoia: "e99828155842f00e960a97fd61b6097ac14d7de1ca10b9b1ee1b89341cc9a4f1"
    sha256 cellar: :any,                 arm64_sonoma:  "04e15dfadb2245e9965a878fb363146ab0389b9c1651047c3124d69b221d017e"
    sha256 cellar: :any,                 sonoma:        "fe0c09a2e38e486459ac3e0ca361aff367149b63a29e9c4ae271499e360e7634"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e7379ab08c492a08f86fa4bd1ed24badfc7ea5f4d6c5add523eda72e1e11371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4d480bc6a607a48b9dbfca3208b13bd8726f05e531027f02d2616e54d3dca32"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end
