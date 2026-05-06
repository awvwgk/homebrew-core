class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.21.crate"
  sha256 "d3b6637a3fad1e5ba842a03d9acbc7779fb51535266f911b883590085c32b41b"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e069911026fbe0ca40c9fe1a991e98dabe19a33047af0747d2b7d36e3fdd8c46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bef0908d94b859d1dad2a3c4991959fb6a77e12c038b06e318a9095af8240b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9335c4b95dd4d98c9491b39c0f6b934aa52b720fa0319f9f9e9bb2112a11ea6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2da8024a1f380f0d2a146bca8ac25391c0204afdf5143564c0a5b4968e1182fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea754da2e210e3f92cbd27ff0ecc81e8b5c2d9a9bb5e3da046e764a2b7cf2c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a47b2140cc18308b790672fd91d1cfc123ed7890f61cecd8ae5d3204c83df44d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
