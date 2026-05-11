class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "1f506aa02222a1dc627e9ae576bca1387079f5e558deb940ac93e5ffd906e8f5"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "120ce92563f525f3a20ac815c896175ce4071fbec1d62c92d59cc50be3c10963"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a8c8d5d59bcf0e429efa69d349ac10e3704f1aceb2d4193749d6b72ce8af1ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a094c56dd4d4075ff0ff3bf955215ae6c96b22af6927aab4c0c356eef1ee75c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e9cd653ca1ee5e2561e1d3c46e1e104977b2ae117acc6de9b869600b60233b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a814d7da969ece785e19756b99c88ea9c032f7084050607110eae8a20759f5fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20d7855719873650bfa164def852ca22784b82b2caccb1dd9ede96ada99be698"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end
