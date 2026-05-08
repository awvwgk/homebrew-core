class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.8",
      revision: "d7539c2264560a8685f59e89a731d6de833258a6"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37008a1ced421aa6ebfa30548605e8b2d059f981937b0b13905a077d28a49685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54580f20f2f4b5f7109e5fb33729d9c808455f23778904a045adfcaae52ad5e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "280793928d59beb2c4fc01337bc6118a5246cd6c9f0a513512eec1acb35d966a"
    sha256 cellar: :any_skip_relocation, sonoma:        "160d95369bd98b058696130cbd47e69aca2f04dc87c238b753f841a7169c2941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa46e0dc519c8c0e2745261fa4fd1f6d3cad8b1e0f12299b29a48035c5075bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "050b95a4358f6288cbce499a3a1c8dc26acd2efe7bff7fcb538c7683424df724"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", shell_parameter_format: :cobra)
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
