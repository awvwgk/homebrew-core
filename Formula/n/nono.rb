class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "851be2591fbab10a11a479730bcbef5fd47c2ccc1000ced2ef70cbae35bebdc5"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "761074efc7c68534933bcf5040db0c68b7195bd85ecdeb1589fde57d58e9d554"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74dc475f167bf996ebacdc5cc7560e1eea0fae881d4cc95ba54e7e8651a5ce4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af76c806d1568b5e938de400b31b051ba5b602fe35be94086c8b84373ecb609d"
    sha256 cellar: :any_skip_relocation, sonoma:        "02362ee2540fd777731d4ea4756d17a7c0c1dc80ce11a5982255ae017b0169c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80e23107d21805b5117d5b72279e55dc134d51562ad889f31c2e48cb92a08138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63f00a6eee51c29b76c00e6ff77f837ce8cd586648f62ed9cc0ff8275965901a"
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
