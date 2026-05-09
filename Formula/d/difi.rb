class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/oug-t/difi"
  url "https://github.com/oug-t/difi/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "c7c044cfe43338c2e8ccb2cbc9e2ade7837a466abdba015b35ce685ad5a27bae"
  license "MIT"
  head "https://github.com/oug-t/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75ab31ec7c7d4ceb4fd2ffcba5548c2bf6cdeda58e19158c875208eaae3dc5a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75ab31ec7c7d4ceb4fd2ffcba5548c2bf6cdeda58e19158c875208eaae3dc5a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75ab31ec7c7d4ceb4fd2ffcba5548c2bf6cdeda58e19158c875208eaae3dc5a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b294f12c33ebc814698fa365e0c83108e3c044297b0622eaecad0fb4a268f43e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1be87cfef6f069cd222a6fa76c8f85e995a78b885d604fb3a438586ea40b3b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2302d04d3af511ea64a2c16720fafec4f7d55c8a4c6f28e0a39ea3982e099e2e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/difi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/difi -version")

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test"

    (testpath/"file.txt").write("one")
    system "git", "add", "file.txt"
    system "git", "commit", "-m", "init"

    File.write(testpath/"file.txt", "two")
    system "git", "commit", "-am", "change"

    output = shell_output("#{bin}/difi --plain HEAD~1")
    assert_match "file.txt", output
  end
end
