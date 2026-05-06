class Qshell < Formula
  desc "Shell Tools for Qiniu Cloud"
  homepage "https://github.com/qiniu/qshell"
  url "https://github.com/qiniu/qshell/archive/refs/tags/v2.19.6.tar.gz"
  sha256 "4f03d2400440d1af6b597de42a6a9469417238a43a5c2a1954fcd7c660970c3e"
  license "MIT"
  head "https://github.com/qiniu/qshell.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3350f9a847eb72aa90f3b1d8d0413fb3c91eb8f2d5279d796cba2c58ac8ea393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3350f9a847eb72aa90f3b1d8d0413fb3c91eb8f2d5279d796cba2c58ac8ea393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3350f9a847eb72aa90f3b1d8d0413fb3c91eb8f2d5279d796cba2c58ac8ea393"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b7935bf2bac765c39cfc38b610bb0cd37a8f2b26a752eb47b964c4e6f0cf0b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44b0cb8ad94c166dc571fddc3739c53696d0dfe9cfcdaa3632db95c92c977bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e186ce6561300fa5ef2ac63051eba8b2964ed21cf4aa1b2c1060b4b25e70732"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/qiniu/qshell/v2/iqshell/common/version.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./main"
    generate_completions_from_executable(bin/"qshell", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output "#{bin}/qshell -v"
    assert_match "qshell version v#{version}", output

    # Test base64 encode of string "abc"
    output2 = shell_output "#{bin}/qshell b64encode abc"
    assert_match "YWJj", output2
  end
end
