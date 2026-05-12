class Diamond < Formula
  desc "Accelerated BLAST compatible local sequence aligner"
  homepage "https://github.com/bbuchfink/diamond"
  url "https://github.com/bbuchfink/diamond/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "d06d26cfa474e17132a9ea4c0a2a7ce4ec7e2ce937606173b401883d62eff730"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2c7d6550638d64e9ca789189c4f822d694fcca0e765443c0fa2998b4da2f9a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62ba0c94bd28e548161cc2179897d2b75811d532b3098dcc9f67ebb62c480192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dae7f8e7e157c0a77d0817c2950d9d7f531bbc2ca1ed128fd77ab7d78f2057c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c1e45f4be99cdf36eba4278ac870af45bac8c5010ac744aa224a181db6693aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7c92e642405a3d76a9e8b433a096664acb38c8b06b43285e077e2a9d1ed220e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8be2b64ed4a75914c642b82fa579a035182eacce99dbf302c8d29220682b4333"
  end

  depends_on "cmake" => :build

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"nr.faa").write <<~EOS
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf1
      grarwltpvipalweaeaggsrgqeietilantvkprlyXkyknXpgvvagacspsysgg
      XgrrmaXtreaelavsrdratalqpgrqsetpsqkk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf2
      agrggsrlXsqhfgrprradhevrrsrpswltrXnpvstkntkisrawwrapvvpatrea
      eagewrepgrrslqXaeiaplhsslgdrarlrlkk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf3
      pgavahacnpstlggrggritrsgdrdhpgXhgetpsllkiqklagrgggrlXsqllgrl
      rqengvnpgggacseprsrhctpawaterdsvskk
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-1
      fflrrslalsprlecsgaisahcklrlpgsrhspasasrvagttgarhharlifvflvet
      gfhrvsqdgldlltsXsarlglpkcwdyrrepprpa
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-2
      ffXdgvslcrpgwsavarsrltassasrvhaillpqppeXlglqapattpgXflyfXXrr
      gftvlarmvsisXprdppasasqsagitgvshrar
      >gnl|alu|HSU14568_Alu_Sb_consensus_rf-3
      ffetesrsvaqagvqwrdlgslqapppgftpfsclslpsswdyrrppprpanfcifsrdg
      vspcXpgwsrspdlvirpprppkvlglqaXatapg
    EOS

    output = shell_output("#{bin}/diamond makedb --in nr.faa -d nr 2>&1")
    assert_match "Database sequences  6\n  Database letters  572", output
  end
end
