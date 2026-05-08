class Marmot < Formula
  desc "Open-source data catalog exposing metadata to AI agents"
  homepage "https://marmotdata.io"
  url "https://github.com/marmotdata/marmot/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "6e6f85402045105220f9c2d91aa3d953c46a3093e530b2d55be8879e00b68c31"
  license "MIT"
  head "https://github.com/marmotdata/marmot.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -s -w
      -X github.com/marmotdata/marmot/internal/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match "marmot v#{version}", shell_output("#{bin}/marmot version")
    assert_match "MARMOT_SERVER_ENCRYPTION_KEY", shell_output("#{bin}/marmot generate-encryption-key")
  end
end
