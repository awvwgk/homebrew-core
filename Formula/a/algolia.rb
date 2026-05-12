class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "eea57596e3db1a6c7432a4ed0c284184ebdb4135c819b5f3a82175bd8b343d27"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eb4f3aa9138008a9e9b48871e05998cf132c8294f5ed05c2eb4d3040313e1a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eb4f3aa9138008a9e9b48871e05998cf132c8294f5ed05c2eb4d3040313e1a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eb4f3aa9138008a9e9b48871e05998cf132c8294f5ed05c2eb4d3040313e1a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c441039cee6eba5412ee890b1ae98a819664da5ac4d34459a2945a5575b1ce9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d58b228c8902843456bd29920b33b72923de1ff8f1db2d92a683700efcd0d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2200ccc55b088dea2ab0aa39e9b2408098ce32ffecb72f767b611521fa57f61"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
