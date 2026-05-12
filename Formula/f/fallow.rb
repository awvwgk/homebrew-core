class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.71.1.tar.gz"
  sha256 "84b29f15715e5ba147b993bb9ecf8c80661ae867e646575d1c29eb571a65d585"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9482cd2eb4d2bd77909f5d50cb8f61aff1b8fc09094fee6e2b417f1232fdb55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "535b9b0608c2517850fbf81d18a96d1a173bccafc09d20e068570aa05aff101c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3808969ce2705d37e5246218c646f3f90e106b552859b12b59f74ca56839e3db"
    sha256 cellar: :any_skip_relocation, sonoma:        "9731ae4a6392e20098801f4f94b6196bb8ae46e35aede63111ef691107e15ee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8106d3002e1a4578c20248c0e8e53ed530aa77a6458bee48befe32f09908cb0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "219bd021c7b250e24067feb563b2afdfb06305b1186c2f507acc99648838a274"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "start": "node src/index.js"
        },
        "dependencies": {}
      }
    JSON

    (testpath/"node_modules").mkpath
    (testpath/"src").mkpath
    (testpath/"src/index.js").write <<~JS
      export const used = 1;
      console.log(used);
    JS
    (testpath/"src/unused.js").write <<~JS
      export const unused = 1;
    JS

    system "git", "init", "-q"

    output = JSON.parse(shell_output("#{bin}/fallow --format json --quiet --no-cache"))
    assert_equal 1, output.dig("check", "summary", "unused_files")
    assert_kind_of Hash, output.fetch("dupes")
    assert_kind_of Numeric, output.dig("health", "vital_signs", "dead_file_pct")
    assert_match version.to_s, shell_output("#{bin}/fallow --version")
  end
end
