class Talm < Formula
  desc "Manage Talos Linux configurations the GitOps way"
  homepage "https://github.com/cozystack/talm"
  url "https://github.com/cozystack/talm/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "c439bcc0feae388a664de71c1ed819b4e379d4d311ca6348b3076b9956bba86c"
  license "Apache-2.0"
  head "https://github.com/cozystack/talm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce1f49a973ad203a9208135039f0f495091dfa8d497e0d01c15c73b4953ce333"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25114e3cbb5003bf00ad94ead87c8a55cf0684abeb26bc03200da0fea703dcea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67b408f448a47aacd42985e88fc2e453c9c0e2803bc72ceda70d579d0533f889"
    sha256 cellar: :any_skip_relocation, sonoma:        "a53762c6aed186c89fad4ce2af7ce1b77e1f36c344fca4494b0b22b22baf809f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d23ce01bc6fa81307ae1f265985a0d202da1085e093ab949437da86fe3b05203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1afcfe9bb20d8114bc706123f1a484fd6a2a4eeb7cd860aa0b976e82f8f6201f"
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
