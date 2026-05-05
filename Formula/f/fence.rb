class Fence < Formula
  desc "Lightweight sandbox for commands with network and filesystem restrictions"
  homepage "https://github.com/Use-Tusk/fence"
  url "https://github.com/Use-Tusk/fence/archive/refs/tags/v0.1.57.tar.gz"
  sha256 "cc29d80141c920eb628f8fca900839f698deea3ce93c74bdef261da21c9d1667"
  license "Apache-2.0"
  head "https://github.com/Use-Tusk/fence.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76774be0c25892356e521a08902f205d6ade5ba2cc33f721886d82aed3b8213a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76774be0c25892356e521a08902f205d6ade5ba2cc33f721886d82aed3b8213a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76774be0c25892356e521a08902f205d6ade5ba2cc33f721886d82aed3b8213a"
    sha256 cellar: :any_skip_relocation, sonoma:        "39b2e7e5a2b7257e8150c5b7e8c841cab38e76126496ba07eec4f07807bd89ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42401cfbabf212827b1ccc74ea4e3c5cbac9f04b6e78ae37f13c4b8b32113a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad986afaca7b36c1f43c1ce654bbe7b60e37fd5d72d0c4d74cd42e335085960c"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bubblewrap" => :no_linkage
    depends_on "socat" => :no_linkage
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
      -X main.gitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fence"

    generate_completions_from_executable(bin/"fence", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fence --version")

    # General functionality cannot be tested in CI due to sandboxing,
    # but we can test that config import works.
    (testpath/".claude/settings.json").write <<~JSON
      {}
    JSON
    system bin/"fence", "import", "--claude", "-o", testpath/".fence.json"
    assert_path_exists testpath/".fence.json"
  end
end
