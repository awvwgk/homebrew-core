class Ncrack < Formula
  desc "Network authentication cracking tool"
  homepage "https://nmap.org/ncrack/"
  # License is GPL-2.0-only with non-representable exceptions and an OpenSSL exception.
  # See the installed COPYING file for full details of license terms.
  license :cannot_represent
  revision 1
  head "https://github.com/nmap/ncrack.git", branch: "master"

  stable do
    url "https://github.com/nmap/ncrack/archive/refs/tags/0.7.tar.gz"
    sha256 "f3f971cd677c4a0c0668cb369002c581d305050b3b0411e18dd3cb9cc270d14a"

    # Fix build with GCC 10+. Remove in the next release.
    patch do
      url "https://github.com/nmap/ncrack/commit/af4a9f15a26fea76e4b461953aa34ec0865d078a.patch?full_index=1"
      sha256 "273df2e3bc0733b97a258a9bea2145c4ea36e10b5beaeb687b341e8c8a82eb42"
    end

    # Apply Fedora C99 patch
    # Unmerged PR: https://github.com/nmap/ncrack/pull/127
    patch do
      url "https://src.fedoraproject.org/rpms/ncrack/raw/425a54633e220b6bafca37554e5585e2c6b48082/f/ncrack-0.7-fedora-c99.patch"
      sha256 "7bb5625c29c9c218e79d0957ea3e8d84eb4c0bf4ef2acc81b908fed2cbf0e753"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia:  "b060799701296da75f956960bbfe2f67b9a529a041bf66c9edfc76450b6bdbbd"
    sha256 arm64_sonoma:   "3ca676300ebb378ef2dc4b7442b15f47df9664e62176b49a1bd7c1d1d0093f42"
    sha256 arm64_ventura:  "79e9c8100ebba864abd6c8534c1d57d1b9d722461b5e3fca035040b3a274b600"
    sha256 arm64_monterey: "4dd658f60d6e9a13f3027bf46c2046b5844114337d348f96e32b542f381bceb3"
    sha256 arm64_big_sur:  "6984005a54a045373105d59303984cab69ebad3b23da23f2608de8c63f1e9850"
    sha256 sonoma:         "ff2c043f63fd07c107395df2c44bd494610d53cc6bdb82c7d603188f3e765a60"
    sha256 ventura:        "c0dfb39809e6c1015c1c41e1b0289326c3000ce7e4e25231b8efc3a555ecc2ea"
    sha256 monterey:       "b85c147ff11ee53640428f7b56114b63344b48867740739e116884c52dcb8798"
    sha256 big_sur:        "1ae6d72f2d5ef01ea183185d6a2ddf7b838649927496eee3481ad8688dba0c1c"
    sha256 catalina:       "ab9acac2396d540a15d92485f59a0bef60434e111fb7045cb8beabfc3facb7e6"
    sha256 arm64_linux:    "1e8fad1cf83a7e0a208d6b078bcb1cc7b3f40101b6aebae28c43a740dc992cb1"
    sha256 x86_64_linux:   "8c7b7248266f093ccb7798273d6b789b4632b7703567e6c534a4322339c0eef5"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "./configure", "--with-openssl=#{Formula["openssl@3"].opt_prefix}", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_f.to_s, shell_output("#{bin}/ncrack --version")
  end
end
