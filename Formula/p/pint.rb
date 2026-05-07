class Pint < Formula
  desc "Prometheus rule linter/validator"
  homepage "https://cloudflare.github.io/pint/"
  url "https://github.com/cloudflare/pint/archive/refs/tags/v0.81.0.tar.gz"
  sha256 "327689c95414bacb6aa6597587ba2c736cd5fd379933e12cd381f792398cacad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "accc4132a4b1b1ffbdbbd399a24c762da52c5b2e367580b3b52f9910db943c9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bf653cae02962991a15276ea48435e1b5daacbd6c26c38a104f27b403fedd01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d4ef20b93582d1d6939ef497dad0fb362a391df3d04407e300624218bb11d51"
    sha256 cellar: :any_skip_relocation, sonoma:        "18bfec17e3caeb1e3f5910e1bfc7261dfcb910290aa83eed11ce7d114ca97917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbeef53c5d64c4a590b9b42974e690374f9b3f445b41bccba7f10dffb3f0ea0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2f1b4acbf14e35635f3c9127d7cfd1d9df4abeccf11710fecbd7bdfc678a1e0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pint"

    pkgshare.install "docs/examples"
  end

  test do
    (testpath/"test.yaml").write <<~YAML
      groups:
      - name: example
        rules:
        - alert: HighRequestLatency
          expr: job:request_latency_seconds:mean5m{job="myjob"} > 0.5
          for: 10m
          labels:
            severity: page
          annotations:
            summary: High request latency
    YAML

    cp pkgshare/"examples/simple.hcl", testpath/".pint.hcl"

    output = shell_output("#{bin}/pint -n lint #{testpath}/test.yaml 2>&1")
    assert_match "level=INFO msg=\"Loading configuration file\" path=.pint.hcl", output
    assert_match "level=INFO msg=\"Problems found\" Warning=6", output

    assert_match version.to_s, shell_output("#{bin}/pint version")
  end
end
