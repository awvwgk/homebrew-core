class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "f16fb76c6c9b3fe4679c8aed393fcbf2f49861e166787bd5dfee4ab1b76ca344"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc8de03538ea5766ff449c1d87857b667a1054ca3d772e8ef46df4a054c83c3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a43cfd1a3f6f290ad2bbd0e0348e2d4d7c8ca19287ef182f58ff82fe72d7aba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20b553bbb9cff2d506dc2ab9999ce79fb8da59c0edb44670807ad4dc5fcbd49f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e475555167ba6e2ad08f901a8569cb8f205f32b769bde945bb74ab4fd6c16ce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bea38b79c45406f03e84be0e03c84a468735f9455fb9381d25fed0dbc2aa6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2190745f98e8b4c723bb039d4a99b8ef748c9a1e9adbc1236a05338307e93536"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/docker-agent/pkg/version.Version=v#{version}
      -X github.com/docker/docker-agent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"docker-agent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("docker-agent version v#{version}", shell_output("#{bin}/docker-agent version"))
    output = shell_output("#{bin}/docker-agent run --exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end
