class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.97.0",
    revision: "3804f048b9c0df42b793c907d5159352fd86312a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3173646b8e2ae3ac327f199ffb8438f4d202eb636e99c24df4fc1fc2692c8d6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3173646b8e2ae3ac327f199ffb8438f4d202eb636e99c24df4fc1fc2692c8d6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3173646b8e2ae3ac327f199ffb8438f4d202eb636e99c24df4fc1fc2692c8d6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc586b7663477c594b5571772bd89e031f9c0455b626625a91fbd5ccdab85f1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e8572f862336c37eec01458f6b92006b909cb291831f1e059e2236a506c934f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ac0d0453c11850786c0f9831f3a3adf805f806e6e1352b4854b128203910f37"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
