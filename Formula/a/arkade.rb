class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.95.tar.gz"
  sha256 "2d3ffc8b727016bdfd4aafa792f9ff79594dd4494fa6c52ae7c007763e692b2d"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ae57be186d683503e7ec816be51eb48b87f249ee66c7a85c7d9423e6d437290"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ae57be186d683503e7ec816be51eb48b87f249ee66c7a85c7d9423e6d437290"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ae57be186d683503e7ec816be51eb48b87f249ee66c7a85c7d9423e6d437290"
    sha256 cellar: :any_skip_relocation, sonoma:        "31f4752141702ed02eb87da2b183b5b4fdd7bc11690778981e60f637b66553ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e13a5d100fab421f1d815a0d4653fc4326a32d173f97cc4310007196d3c03b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7751cf60e5f5cc656a7424f7fa78c65195b8cde5de79da73014f284adc21d531"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
