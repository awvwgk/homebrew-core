class FreshEditor < Formula
  desc "Text editor for your terminal: easy, powerful and fast"
  homepage "https://sinelaw.github.io/fresh/"
  url "https://github.com/sinelaw/fresh/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "9c493f2af15d2b87b672a67a3701b2e92a0835537fe171e3c0102224484d1d36"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5806c34048016fce13ecbb88096195b2710ab6de4a713e80ac13e34d2412a99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18619551d020f0a9f186d55b2a6ef19269f86b426bdcf7d28ed7bab075380ce2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "593025a67e38841b7d050b2026504a0b8b545f78026714ba3c280c79f6f391dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "304329ce3cf5d7c21fcdf492b3960973d1ee39c0927a129301b0112b7f8b1536"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00786a1dc4402c68db8ced6b8544583caba8d0ca566ae40115d56c8dec045674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22e1305524672751de021a8731d7073df8fe6046fb339a4ebb5dfad5cb673dba"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang to build rquickjs-sys

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fresh-editor")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fresh --version")
    assert_equal "high-contrast", JSON.parse(shell_output("#{bin}/fresh --dump-config"))["theme"]
  end
end
