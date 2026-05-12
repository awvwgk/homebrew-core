class Zapp < Formula
  desc "Flash ZSA keyboards from your terminal"
  homepage "https://github.com/zsa/zapp"
  url "https://github.com/zsa/zapp/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "c4e03dba5d87295d565c6681b3b13956160c364be637bd6756d438fdb3959e4e"
  license "MIT"
  head "https://github.com/zsa/zapp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcaf5d6ec9bde24d517e28d17ab583ad4af8371c890cdaba9a003de9f36bd114"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "753c8179fe7c6a9e2db59f00c2af1e1413a1842ada0ad8cef35ded525a9cc6a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20b9b479e016c1068fe709587fc9d43216bc43e97985470d90d180410e4c17cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9f955f854a69aa6de639335c32d9d42059c1fadf5db32acfa75f966e47f55f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "491797a586290c5e217a970322ce3092e388e92d62238b427d477d1d0ebd8e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d17ffe8c6e9e8987502e38c2dfcb26d70f098c4778f17f7a9dde76f3ae776b"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "zapp")
    (lib/"udev/rules.d").install Dir["udev/*.rules"] if OS.linux?
  end

  test do
    firmware = testpath/"invalid.bin"
    firmware.write "not valid firmware"

    output = shell_output("#{bin}/zapp flash #{firmware} 2>&1", 1)
    assert_match "Error: Failed to load firmware", output

    assert_match version.to_s, shell_output("#{bin}/zapp --version")
  end
end
