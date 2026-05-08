class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-community-3.27.1.tar.gz"
  sha256 "878e52c4a6cc3bd28048b527a920fba86ce4cd99c5760adc42417a811efa6e6b"
  license all_of: ["BSD-3-Clause", "GPL-2.0-or-later", "GPL-3.0-only", "LGPL-2.0-or-later"]

  livecheck do
    url "https://cfengine-package-repos.s3.amazonaws.com/release-data/community/releases.json"
    strategy :json do |json|
      json["releases"]&.map do |release|
        next if release["beta"] || release["debug"]

        release["version"]
      end
    end
  end

  bottle do
    sha256 arm64_tahoe:   "88253c85fccbca421d2196a0f5bc2f90156d48fe00f30da27b5f35b2710981da"
    sha256 arm64_sequoia: "e9a9d144edc93a46a5d22e950081937a61834c5c855d6587f9dd19ee9e2f5f8a"
    sha256 arm64_sonoma:  "d819919d8817ed210999d70b3ff83e268c628bd2ad6bb2047bcacfb9ec281bef"
    sha256 sonoma:        "e0e0d90a26cbd07bdf1909a034fb4c928baf2e445a26b22964e1aa8a61ab05d0"
    sha256 arm64_linux:   "8903b84dc6823ed93ce4efd43b3c8fb634690dccd7f8011526cf21b91914293b"
    sha256 x86_64_linux:  "2d141b557648c744e4ff619b81d2590e27d1568d2bf6ad9939ce718c55c1832b"
  end

  depends_on "librsync"
  depends_on "lmdb"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "curl", since: :ventura # uses CURLOPT_PROTOCOLS_STR, available since curl 7.85.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "linux-pam"
  end

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.27.1.tar.gz"
    sha256 "fd32c1255c0114d55929b496a15a6a6f48231f108be23f50ad3b8abc2e734ccf"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "masterfiles resource needs to be updated" if version != resource("masterfiles").version

    args = %W[
      --with-workdir=#{var}/cfengine
      --with-lmdb=#{Formula["lmdb"].opt_prefix}
      --with-pcre2=#{Formula["pcre2"].opt_prefix}
      --without-mysql
      --without-postgresql
    ]

    args << "--with-systemd-service=no" if OS.linux?

    system "./configure", *args, *std_configure_args
    system "make", "install"
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  def post_install
    workdir = var/"cfengine"
    secure_dirs = %W[
      #{workdir}/inputs
      #{workdir}/outputs
      #{workdir}/ppkeys
      #{workdir}/plugins
    ]
    chmod 0700, secure_dirs
    chmod 0750, workdir/"state"
    chmod 0755, workdir/"modules"
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
