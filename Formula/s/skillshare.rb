class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.19.9.tar.gz"
  sha256 "a52db6789ddf2e15181c20a8e8febe20589396b58c5dcb0d84bccadde6b3ee89"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95f4c3d5d1f90371270a3d50bdbb4b10641e98f8876e4007485b1505297846cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95f4c3d5d1f90371270a3d50bdbb4b10641e98f8876e4007485b1505297846cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95f4c3d5d1f90371270a3d50bdbb4b10641e98f8876e4007485b1505297846cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "458c0a910b4f51a6de9f678ba77a51d3696df2999d9cf03bbcdfedb929d04194"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3b65ca4d8631a5b4192baee72d8b98e8a68c080d3d1a22283ea508206d5e4af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd22a699c6a26a613fda4a1de46b331068f5b5827e76a89d82cc77f8772b144a"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
