class Fallow < Formula
  desc "Codebase intelligence for TypeScript and JavaScript"
  homepage "https://docs.fallow.tools"
  url "https://github.com/fallow-rs/fallow/archive/refs/tags/v2.73.0.tar.gz"
  sha256 "27c8a27d9a222d1f5a0e2ca52aeb06a0f75c850bc59fd8e7878abb3bea5d6a56"
  license "MIT"
  head "https://github.com/fallow-rs/fallow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e28bfa6acf048a4f3a04f00cd751c30567e8f99e7042e9962a507a60f3917694"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "923a37743fd2064c7f72bfc5fa70c484e5f2361e0ac3757b6a6c299b97d66da7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2764ad567ebaa81209ee39b182dd77da0b13e616fb4eabcf010c289f57d81115"
    sha256 cellar: :any_skip_relocation, sonoma:        "054cdf1183773113847617907d4d6e759cebe0e9c44affb0e58c7a9db2921346"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d75c979619d4b85d6d38daac72254ec0457d697c8bb04f78bce65ad6917d06f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb15d68362fe37b3f1869508a83137126d7308d2246b5d8ce3a950c2438223c0"
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
