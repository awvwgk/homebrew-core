class Paml < Formula
  desc "Phylogenetic analyses of DNA or protein sequences using maximum likelihood"
  homepage "https://github.com/abacus-gene/paml"
  url "https://github.com/abacus-gene/paml/archive/refs/tags/v4.10.10.tar.gz"
  sha256 "173e8754ad78000371099a96910f2c72b03a7b7b13c717405dc23385ae2f2c0f"
  license "GPL-3.0-only"

  def install
    cd "src" do
      system "make"
      bin.install %w[baseml basemlg chi2 codeml evolver infinitesites mcmctree pamp yn00]
    end
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/.", testpath
    output = shell_output("#{bin}/baseml baseml.ctl")
    assert_match version.to_s, output
    assert_match "lnL", output
  end
end
