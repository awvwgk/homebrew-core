class Gonzo < Formula
  desc "Log analysis TUI"
  homepage "https://gonzo.controltheory.com/"
  url "https://github.com/control-theory/gonzo/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "822a723c7e8ac46a10a8a25762b76f98d3da76299dec19154d80db8a072afc31"
  license "MIT"
  head "https://github.com/control-theory/gonzo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4abbaa899639e2cb0bde0461b1b65d70f35b6a7d7cfb25f9e78f3c190064e457"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4abbaa899639e2cb0bde0461b1b65d70f35b6a7d7cfb25f9e78f3c190064e457"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4abbaa899639e2cb0bde0461b1b65d70f35b6a7d7cfb25f9e78f3c190064e457"
    sha256 cellar: :any_skip_relocation, sonoma:        "a31478cc4f34a28881d8afb3423487a1d04422366d3abd62652e146ccac21c7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "086aebcd591b82b1eba4fdd3d2cf5eed04898daea6ef69bd38270e0aed945907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fa5065bfbf7af92c0a63322ba09398042a6b56501baca1f089be1acdc4e3592"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    # UI build
    system "make", "web-build"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildTime=#{time.iso8601}
      -X main.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gonzo"

    generate_completions_from_executable(bin/"gonzo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gonzo --version")

    (testpath/"app.log").write <<~EOS
      2025-09-01T12:00:00Z INFO app started
      2025-09-01T12:01:00Z ERROR failed to connect to db
      2025-09-01T12:02:00Z WARN retrying connection
    EOS
    output = shell_output("#{bin}/gonzo --test-mode -f #{testpath}/app.log")
    assert_match "Test completed successfully", output
  end
end
