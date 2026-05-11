class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "144619fb25dcddc3fad8457497f0ffd8e3f9e19005303a752d4401ec2250036a"
  license "AGPL-3.0-or-later"
  head "https://github.com/grafana/k6.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62ab7b0eb3a8bccc50bfc0dcacff52a92a0b075eeadb5e8ac91bb4a59489815d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b317fee79ef341f452740cec29e0c1a59fb2b00ba839fd868fdd6de2459dba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "240e4a7e5c525cc307f740af98ca6d365b174b224001c3f9cef50aa3496342aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6638788e530e29d701961cf29ded955cb417bd26912418245ebd13ae7ddc681"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2391eb9136ec8aea2b300e8bbc8cac487e1435d371a4b0460c1940679898402a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d074affb6ecb19059f0eacd2a22f71d03b354f8c4d2e78389a8369e6770cd3b4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")

    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
