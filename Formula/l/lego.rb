class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "7d4430a7890026bc93e93fd0a892873eb83a497580fc5cdbce71d06b22196e9d"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e47e9bc7be0cff0c0f210c98b00f50e34ce31f8e409184355935ac7eaeab6e35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e47e9bc7be0cff0c0f210c98b00f50e34ce31f8e409184355935ac7eaeab6e35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e47e9bc7be0cff0c0f210c98b00f50e34ce31f8e409184355935ac7eaeab6e35"
    sha256 cellar: :any_skip_relocation, sonoma:        "91b0a6ecdcb224524915fd25198d48cb622cd3ad000ee10807e463dbd7319947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77294fe2f976e244deba69e7b7d203481fc7dc8ced4645a12f00a0c51b2cde61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c01ade80a2e560e8d848dd3846d5dbf36c59bbdd87ee107ce02f47305359d806"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1
    )
    assert_match "No account exists with the provided key", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
