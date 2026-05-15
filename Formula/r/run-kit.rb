class RunKit < Formula
  desc "Universal multi-language runner and smart REPL"
  homepage "https://github.com/Esubaalew/run"
  url "https://github.com/Esubaalew/run/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "dedb97026e4a7f1121994f659a32896500f5521626bf19a55283a0d948510a14"
  license "Apache-2.0"
  head "https://github.com/Esubaalew/run.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7afffb66ec5c3695889fc2e1f269384210242e05436545213d4c78c21e3998c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efc894a3a4936a08a977d7f30554b665c2300e4a4e22874308ee2cb809b7194e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "061595ae2ab7e5c21c760536c2e251d161ae05b9ee919019e58e5811b37a7bf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "43fb717c8d77178f0c157a81fd27395011b4ba68dab0115343a291b2f36be7b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b70dd320fe66d6d4330026007fd039b36f0500491cefc4f1a39e763358e08947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9adc315afb6765cf19a8ffa56a0d0ca3c074c752186be08f4a6d5ef53a369093"
  end

  depends_on "rust" => :build

  conflicts_with "run", because: "both install a `run` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "brew", shell_output("#{bin}/run bash \"echo brew\"")
  end
end
