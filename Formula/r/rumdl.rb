class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.91.tar.gz"
  sha256 "bb1e3e7a08203456020e915606bf50d3f85708c14ac10367743628734663bd3d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c395a77ef45a3e38b0990e43cd1e7c642f9c374b108a4fc4ccb6dffe1e609511"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "853aaf71d6093a97835c03522b519ac504c355925fa523de777485579a511d91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0c35660ff056814a412e0d7eed31ebbfafdd168cc83343826f90b84c19029f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "759573e3eb6ec9ff57b860cb779b5f256c32ac47588d76c3058019d8f1b85efc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4462b64e1125cd02185b827a41373b56cd7adbeab927f12c3918e51b1aed537b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7b56cc74d983d7276e0091bd148394cb15c55dea8ccc44363ef81eaf113e180"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
