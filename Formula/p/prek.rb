class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://github.com/j178/prek"
  url "https://github.com/j178/prek/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "3bfa9e8ddeff7733b83cd2e7c96842c383aa922c9d8f8e683f7e67e63808adf2"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e13d0735be317c47f59b7907b69c6209868115cc743cc8a8aa562dc5c7cac8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3af5bde17d3c230e4f5705ab6738b44eaef33b591441aecae70e5c0228c1292d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90550f715f18a10901f17ffa5bdf789709d17d7ae27886759642927523513d9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "18950d1189dbd5e52362c955aec7f942659ffa2895f3ad7338516544c7937b1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc21f62a4bd4c934487369f9de379323248b2ac5c4b511f83efc4f099556bab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d475c3519f37bdf949be5b186436caf8db4660e980a8dbb97d51e5f620cdb61"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
