class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "91f113be2bf8385ae5c42979fd36619f93473bfe0c763e952c236dbac63dd9c0"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "c142e2d50d897435e4a2ba88ebb37768ef89a220fb73350ee97909fadd268644"
    sha256 arm64_sequoia: "02f34b20538a8d0fc30502df1451960c7c7f8082734f97e78deef9c872225356"
    sha256 arm64_sonoma:  "5421e053ebd3d196059e6cd5a1806eeae11b0156dd43c9f4dac4a6af256057c8"
    sha256 sonoma:        "be4b9a83876d8ac6b39926eabadf972d9fba26c57e877f9a14be9a76e6d54b85"
    sha256 arm64_linux:   "1734d246a8032154b2e0ca9d32fcb828cc15ae212fbe3065374568693e03f46f"
    sha256 x86_64_linux:  "f3764d169026deadda63a432e3a7078e1d860b563d5a143a35d7c423406c129b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}/re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
