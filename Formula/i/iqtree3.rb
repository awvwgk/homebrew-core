class Iqtree3 < Formula
  desc "Phylogenetics by maximum likelihood"
  homepage "http://www.iqtree.org"
  url "https://github.com/iqtree/iqtree3/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "f748572d205609040a790df44c7bfa49d8b01ae174e123e927911696befd78c5"
  license "GPL-2.0-or-later"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build

  uses_from_macos "zlib"

  resource "lsd2" do
    url "https://github.com/tothuhien/lsd2.git",
        revision: "c61110f3a4fa05325b45c97b2134792ff9d55d4c"
  end

  def install
    resource("lsd2").stage buildpath/"lsd2"

    args = %W[
      -DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3
      -DIQTREE_FLAGS=single
      -DUSE_CMAPLE=OFF
      -DUSE_TERRAPHAST=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iqtree3 --version")

    cp_r pkgshare/"example/example.phy", testpath
    system bin/"iqtree3", "-s", "example.phy"
    assert_path_exists "example.phy.iqtree"
  end
end
