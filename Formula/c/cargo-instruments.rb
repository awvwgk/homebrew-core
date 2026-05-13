class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/refs/tags/v0.4.16.tar.gz"
  sha256 "059e6f290517503746bd3fe31bcbb5c5a5c65895ee163ce07cdcbe555eb233d2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "b31d3827d6b1c33bce56424c8a745ddf2efdfd83b4333c47ab321a8308d9907a"
    sha256 cellar: :any, arm64_sequoia: "29e767ab55c7706803c867030a317553fd415d92830c15d3476bad4f66055863"
    sha256 cellar: :any, arm64_sonoma:  "35f14a2c4e195c24786c04b39a4a637a1bb62ed000dfb49ca653a70e7ead694a"
    sha256 cellar: :any, sonoma:        "4d41b34fe86e84e1acf5b8df0e06d44fbf385cc7742e2922ea4d34ca49e4d0ee"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-instruments instruments --template sys 2>&1", 1)
    assert_match "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory", output
  end
end
