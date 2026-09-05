class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/refs/tags/0.57.3.tar.gz"
  sha256 "4321e51753723f87b1e83093b831ff54ce37e664683573cc84a68b39d2156153"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1862d7ff96cdac8acd98545c231ec0641832db3b99a5ccb21f29dfede3a4d935"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a3358b662b5a3c30c46641503913211b455f91f305c5c14ed824215bd8e8c8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54ccc2ef7b4de0e81591ff1f8768a1d66513058bab95d73cf81580562376e480"
    sha256 cellar: :any,                 arm64_linux:   "32cadc8e401771f0577705d702365387abaa0943ba15eb4bc954ba8ad48691e4"
    sha256 cellar: :any,                 x86_64_linux:  "009966bc35a5d752614ae6b79457e723603aec80ac191cdb42a6e9f91313443c"
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
