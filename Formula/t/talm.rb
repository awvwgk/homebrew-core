class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "2150a7680e2e6baacde1f7c08d4d8aed632f75c7c2166120bcb1b65f8772fac5"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e87fbceff9105e025ac819e4e571927f4558a8803b4159724a481dd53952d9ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b25a7ca33a9a6ca18150d309e7a220245681c0c353264ed30cd0884d5c9b257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d697a67523e03abc5c8925fef1255a1a66ae3f45968a6fc2b53bef834931acf"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3d9b35e1ce90824e7131a4fce2dd4cce47ba449a28ff3062ba2460694d9542e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d5ad31e00d7f749f8522295b0c89b1e09794ab252f4ead62ddb92ca87cd01f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0994db1e6567a3531c89df4a7850d7368ab3416ed345c825939d4318032e46"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"talm", "completion")
  end

  test do
    assert_match "talm version #{version}", shell_output("#{bin}/talm --version")
    system bin/"talm", "init", "--name", "brew", "--preset", "generic"
    assert_path_exists testpath/"Chart.yaml"
  end
end
