class Adapterremoval < Formula
  desc "Rapid adapter trimming, identification, and read merging"
  homepage "https://github.com/MikkelSchubert/adapterremoval"
  url "https://github.com/MikkelSchubert/adapterremoval/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "08145e38f27bfd94e9c95864365726bc63e9325a8b39b973b9ab6c87bd8c93aa"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d55def0eb8e4d90874c3462c3c2088ee0addd14709835ce600cd277631c94a62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c89e56b55bd143ad31f49b4f21a9a90dd1b2ec589bc93c762b3921a0e5bca28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf4e7d64e4c63c3b1626cc6a4073169bd10af09a31a83c42bb04d3343158198"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d23629123200eacea62c12486cc564549941a3ad868e9a234122b83751afa57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "811e8cb621752ab6dac595d0c716d6d77bfc26254c0a5eb814760c91f2abae94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06fb66c36fde9bd21bd005089ff665eb257a5ed15751414fca394457b27c388c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "isa-l"
  depends_on "libdeflate"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      -Db_coverage=false
      -Db_lto=false
      -Db_lto_mode=thin
      -Ddebug=false
      -Dmanpage=enabled
      -Ddocs=disabled
      -Duv=auto
      -Dharden=true
      -Dmimalloc=disabled
      -Dstatic=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    pkgshare.install share/"adapterremoval3/examples"
  end

  test do
    examples = pkgshare/"examples"
    args = %W[
      --in-file1 #{examples}/reads_1.fastq
      --in-file2 #{examples}/reads_2.fastq
      --out-prefix #{testpath}/output
    ].join(" ")

    assert_match "Processed 1,000 reads", shell_output("#{bin}/adapterremoval3 #{args} 2>&1")
  end
end
