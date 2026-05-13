class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.8.0.tar.bz2"
  sha256 "296b9db9095749f2aa104202d7ab7fd09ad10710e00780a709c9754b1a1d9292"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c8397a90c3319b01a7a1fb918a744d4955d68ac35014cb6b970fddabcc9a978f"
    sha256 cellar: :any,                 arm64_sequoia: "40e470b7a2063e44d2be4de5ce729ca055262b9f667bf812fb1cd8617bcf9433"
    sha256 cellar: :any,                 arm64_sonoma:  "0027e64410b8ca621b56d4fafe55fe8c18f140373740d30d5a5d02138ac807af"
    sha256 cellar: :any,                 sonoma:        "ed1599c59f472be25bd8ec3260ab28d28b22cee360f0b0209961c3f76ad6b37a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd3d03f38475edf731137ef9b20dc6bc89de04077fe7f19739e2a8afd62e424b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aac1e689711348bf81c4837fcd90c76ca80cd3424f6ff639c979e337ec8b081"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace [bin/"ksba-config", lib/"pkgconfig/ksba.pc"], prefix, opt_prefix
  end

  test do
    (testpath/"ksba-test.c").write <<~C
      #include "ksba.h"
      #include <stdio.h>
      int main() {
        printf("%s", ksba_check_version(NULL));
        return 0;
      }
    C

    ENV.append_to_cflags shell_output("#{bin}/ksba-config --cflags").strip
    ENV.append "LDLIBS", shell_output("#{bin}/ksba-config --libs").strip

    system "make", "ksba-test"
    assert_equal version.to_s, shell_output("./ksba-test")
  end
end
