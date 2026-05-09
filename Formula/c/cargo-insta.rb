class CargoInsta < Formula
  desc "Snapshot testing CLI for Rust"
  homepage "https://insta.rs"
  url "https://github.com/mitsuhiko/insta/archive/refs/tags/1.47.2.tar.gz"
  sha256 "487c7348fc8865fd3218c4252f2603238af1b6ae3501fe51577fb5abd4fe5323"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-insta")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cargo-insta --version")

    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    # Switch the default toolchain to nightly
    system "rustup", "default", "nightly"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "toolchain", "install", "nightly"

    (testpath/"src/main.rs").write <<~RUST
      fn main() {
        println!("Hello, world!");
      }
    RUST

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test-insta"
      version = "0.1.0"
      edition = "2024"
    TOML

    assert_match "done: no snapshots to review", shell_output("#{bin}/cargo-insta review")
  end
end
