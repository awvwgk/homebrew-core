class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.19.11.tar.gz"
  sha256 "a685f9c4a3e40a89bf363ef16746047830b26cfafaf1f480b4fd66f071083ad3"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54e8da147504cdcd9d3d910b25aa510c4724f15d69ee5c3a3f40570cede1e9ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54e8da147504cdcd9d3d910b25aa510c4724f15d69ee5c3a3f40570cede1e9ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54e8da147504cdcd9d3d910b25aa510c4724f15d69ee5c3a3f40570cede1e9ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "611405dfe41631066f28e041f960cbcb7d327fc32990c64e3858446c4cbf7bd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e85f550fd16387f31a7a2dffdc11ce4111f10f425c128d8977912b655429fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c47fefa0d39d6b63ecb52facb4f98a56c677c99960f10415d5b7310fbf141f19"
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
