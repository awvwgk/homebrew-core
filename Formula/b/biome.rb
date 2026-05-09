class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.15.tar.gz"
  sha256 "a6195ce3a4575ce316d2253517118f49edcd199a072880748e50170c6993e513"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed431d8cde97df47b699c08529de8b311d58d3cb5780fa934cd36c309ad809be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50ccb15e63e00f81cffb4eb9ac5f52bfb78f733e4f7e481ae230237ebb1caa5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6c6c0ab792c4957869c1ee6a42c1e61a829ae14323ea9f22ffdbdf2b4ff570a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5cff26cb8499d8f351c653bc89da8f7603b723ee7e56cdf92baa6d9975f1c2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a0dff9544558b76fad89b8c86d6131399127b1231da52e8e8eab8c5ca7ba765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd0e7c5890610e0bc9a7d554ea9cb8a30bbbe1bc5bfdf70965db39eacec97a35"
  end

  depends_on "rust" => :build

  def install
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end
