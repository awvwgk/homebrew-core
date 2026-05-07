class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "c650fd685ec811a01dbf1437936730883722b285852ccef5440c385c8fd8f3b2"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e68a10ce62d274861fbaa438fe74f01fcd173a83a8754bdcd05fef6751449c5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "677f4d4865f97bd7d3bdcddb23cdb1f18118beb5b2b94c14b0f590e4d8b7a1a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32a02f8e565f027b5fb4d9dd4d011e5ab16782830f4968d70b803537f5707336"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1edd6f35233b973af3dbe371fc118fdc7bf26bd2c898ae76c10d97a850614c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99bf07444ccb3511c752e2acc78010e4f04e50981c0ff3d6b02c5d02c51f101d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcb72f48f5fc6c8feaaaec810c48de4e3c37018fd3ed02b1b9763a75ae46ee9d"
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
