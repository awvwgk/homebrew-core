class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.19.7.tar.gz"
  sha256 "83a0c08f2bd6509124b8a578d76f67e56fc8b0e3d05a12bd810f0ecc0f6b831d"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0942f1906904f1571a97e8ba27d0332a55921f0ce1229d4b75de876458129e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0942f1906904f1571a97e8ba27d0332a55921f0ce1229d4b75de876458129e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0942f1906904f1571a97e8ba27d0332a55921f0ce1229d4b75de876458129e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "00c6685975fc654b4c8026e4d6291800ac90eac67abd5db9321fd7f812757a20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9063b9bf3b3261b6330281e29da21ad47b701086234020639420fa9d9e15efbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7cd458976244604b4fb4823fe62b31ff526e5c00cb717d4df05d379aa1a9d82"
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
