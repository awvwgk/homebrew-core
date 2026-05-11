class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://github.com/always-further/nono/archive/refs/tags/v0.52.2.tar.gz"
  sha256 "b5bd496c697fff5d71a4c494fe90ab974a89272d64890d1f4ca95a4b2ae0e1a4"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "380f0feb4c517f8a129eca0956ecd6a4a87f1eda154e902e26623116e00535fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c8494db7fa0d677587faa33ca674ce527445acf3ca0c0e31dab1c0d2118b601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b71e524a662b7e92e38e79243fa757f38bb30e5e1af8f716de2c76b137c332d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3cd67385c4f1fd0ff8969f912fcf9ebd9d31ca8f0f1356ae4cbdd1cb4f546d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28fa823c7d26085f65ddcde71bdc58e2e7c21775c083be6957ae38d01ace89a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43cf11448fcb26690a7cb07342aa8f30ce467f9748c0b9d161391eec7603d199"
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
