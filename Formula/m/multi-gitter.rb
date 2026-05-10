class MultiGitter < Formula
  desc "Update multiple repositories in with one command"
  homepage "https://github.com/lindell/multi-gitter"
  url "https://github.com/lindell/multi-gitter/archive/refs/tags/v0.63.1.tar.gz"
  sha256 "44114005fd83484a9a3f066aff58cc5d75607a6af14796eeb3c90ab45a70c211"
  license "Apache-2.0"
  head "https://github.com/lindell/multi-gitter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b3943b366e3301b5c34c16b77ea4db8189ef02ed5d5a8e4ea6ed474c32d30dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b3943b366e3301b5c34c16b77ea4db8189ef02ed5d5a8e4ea6ed474c32d30dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b3943b366e3301b5c34c16b77ea4db8189ef02ed5d5a8e4ea6ed474c32d30dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e5f043cd0899e24578bbe178d22ed789e8a39c3c0b212ab6295f9fdccc9d3dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69a9160c4ad92626e13278cb06b0ff8f280c14cfd058cb5c99e03c6fb852b235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "939974a2fedb75398b3cde45ff269e80746ca89e4094f17890b4595fc5648832"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"multi-gitter", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-gitter version")

    output = shell_output("#{bin}/multi-gitter status 2>&1", 1)
    assert_match "Error: no organization, user, repo, repo-search or code-search set", output
  end
end
