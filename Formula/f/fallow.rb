class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.72.0.tar.gz"
  sha256 "2780a59c1e8bb61bc58271bc53f1ca8e829e18d2c8411980c6b721114ee5336a"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de5b018a7243e6c47269fd54b1f089d44c547a0350cae1bc1eee6aa090ac36b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c85cf4f684576cf032c6b341890607d0c2f64a62a8a33c8a3b1f916c048c87e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba356c60775d000bad9681f0b9b516f80d135120dd4921842dc0619e4e1520cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f3aac60970d4eb637c561e8776cdf203cee51ea963a90de4d4344c933a8db3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38b7ccc73cb36cdc26a2ed720ce36474632db00ade16e7cd80c38c0390b4fc1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a6255c176dd68e2699c5ac2bb6e5b0525d9a267f432c5192fa1822521c355e7"
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
