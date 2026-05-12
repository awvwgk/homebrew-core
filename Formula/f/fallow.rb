class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.62.0.tar.gz"
  sha256 "abaa60d6137c24ea1120545226ef3a01f1b43af4364e6c4a1d2668071203fd01"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f54c1ea247aafb67e156085e001167304eb4555b00e2602fe0f7556020e97861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5e0d1696cfa37b25d87b64ae3a540f0de65c0713cf35882e52f88875a9cd0f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ae94d080a5037c8fdf6149beaeb3dd1a42cb1cafca18d43f1059f9a698e2296"
    sha256 cellar: :any_skip_relocation, sonoma:        "83ea42a02411725d7b513861e31c71e9dfd158f38b013a626a395b1103cf7121"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b1497d3e71c07553a24dd7a0a616e313767e0cd567105ee58b26138a38562d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d542292df72d179b885400b4f1dc88ffbe0cb40dd45507af792ae2a5a45df10"
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
