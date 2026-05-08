class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.205.tar.gz"
  sha256 "0c1567e6a8f4f834957d56bed4996d6e20cca2733ac4860bc98b1d4c9f4c3669"
  license "GPL-2.0-only"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "407809308902edfa3c9dcce24725a0bc6a5f292476169b654d71bfe9c78f5a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9b3c93dd236bed2837f9b6c48ebb6d37eb1dd4402ec2e9bf345d5cfdda3a9dfa"
  end

  keg_only :versioned_formula

  depends_on :linux

  def install
    system "make", "headers"

    cd "usr/include" do
      Pathname.glob("**/*.h").each do |header|
        (include/header.dirname).install header
      end
    end
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end
