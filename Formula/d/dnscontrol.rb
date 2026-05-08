class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.37.0.tar.gz"
  sha256 "15e67649723ca1ff6f0eb7c3338f39b9090ebf806888ff9233ea807a47383346"
  license "MIT"
  version_scheme 1
  head "https://github.com/DNSControl/dnscontrol.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9fe5027e13eeda9dea7c7a988e77f1b9b4001ae66ec47d0d40c146c1d5c75ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d48f33be07493fac53ebfe46565525a737a9421d7ab7b5c9cca1fefdd4a4aa11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef370477b26b844a52fa01fe75c0c38f6c9c6198b81c91e2e97bff5d9e9aecb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a3fcb3a7b94720d84c92900386dcc26c4cb4dd5c28b33ac39c29d511d2c0377"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "907e4563457004e03c55d65958fa2bcd23c4285188e7af46ee83b35a25183d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c0749d21801b706590c9eb664a4194bf721457f22675903b7b1a11a1fc6a62a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DNSControl/dnscontrol/v#{version.major}/pkg/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"dnscontrol", "shell-completion", shells: [:bash, :zsh])
  end

  def caveats
    "dnscontrol bash completion depends on the bash-completion package."
  end

  test do
    version_output = shell_output("#{bin}/dnscontrol version")
    assert_match version.to_s, version_output

    (testpath/"dnsconfig.js").write <<~JS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    JS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end
