class Apfel < Formula
  desc "Apple Intelligence from the command-line, with OpenAi-compatible API server"
  homepage "https://apfel.franzai.com"
  url "https://github.com/Arthur-Ficial/apfel/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "ec6253436da2b718e77caacd3b2a04d0529c3ea3dd87611dac65641eca8950fd"
  license "MIT"
  head "https://github.com/Arthur-Ficial/apfel.git", branch: "main"

  bottle do
    sha256 arm64_tahoe: "77874c88b5294810584793fedfdc3e2745cfba59162d120e6fb67b1c38feab1a"
  end

  depends_on xcode: ["26.4", :build]
  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/apfel"
  end

  service do
    run [opt_bin/"apfel", "--serve"]
    keep_alive true
    working_dir var
    log_path var/"log/apfel.log"
    error_log_path var/"log/apfel.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apfel --version")
    shell_output("#{bin}/apfel --no-color --model-info")
  end
end
