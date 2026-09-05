class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.57.3.tar.gz"
  sha256 "4321e51753723f87b1e83093b831ff54ce37e664683573cc84a68b39d2156153"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1d68a39700319d3a70bac15f7f65fd556f1481330a2f70019bb8b8bf1f4b0f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "207a3393f88cef3ec06a202a0dca781a3580e9471d892506b8d616b6fc08adfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71a0497e0e8b3376e83530b2d3c0b702b5cb36939a125491f31f6e41776e7304"
    sha256 cellar: :any,                 arm64_linux:   "d2c8a94291992bd52db1730a0392cb773ff244b302a4ecaa6b3b216498777ede"
    sha256 cellar: :any,                 x86_64_linux:  "d940685ba5525c93d9285f664505fd5fa16b5f649f56d5538013af1792bf094b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz" # required for lzma support

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
    generate_completions_from_executable(bin/"dprint", "completions")
  end

  test do
    (testpath/"dprint.json").write <<~JSON
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    JSON

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
