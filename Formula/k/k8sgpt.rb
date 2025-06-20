class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.19.tar.gz"
  sha256 "6b237d65cb1ebe4af1618eb6ff0b807cefbd5d46bd0d8ab40de73f2e1074fd10"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80359e8e81588e65e3afac6e4e8f04cd98a4a848eebc37bf2b8b2359c36f9d04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd984f79e295807a18e3f7ef63f0ba2d387cf05cfa23c77beb543b85e370615e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1623164fd59fb4032c85adbc5312b60fe060f307d82f65c1ebbd50e8a1abcb11"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7b3efdbf67557d32f0301756413f1267ad961d5c037e2bb6080ece83619f9a5"
    sha256 cellar: :any_skip_relocation, ventura:       "81e9af735d1a65b56bb4f1ddfa9422b2539aa356c4dfaca5b9a0919d9f3bc21c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaf17023005bc801dc93aff7a2b0aac2a0f282477267385641ee209e136fc776"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e51ce2bf521eecff38a49229afcaef356c3dde138d210d15fde033c521cce3f0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k8sgpt", "completion")
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
