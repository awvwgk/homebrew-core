class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/refs/tags/v2.40.0.tar.gz"
  sha256 "8d8399d3168bd97abc68e2fafdeac07bf59fed1afb162c19d1a30f87941cf6dc"
  license "MIT"
  head "https://github.com/bitrise-io/bitrise.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fbaaa3d5d9b952cf52739ca6157e43d8af7f95cdf498ade7e36cdb9bd02399d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fbaaa3d5d9b952cf52739ca6157e43d8af7f95cdf498ade7e36cdb9bd02399d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fbaaa3d5d9b952cf52739ca6157e43d8af7f95cdf498ade7e36cdb9bd02399d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dbb138edbc707d202daa25c41181f1b33d45dfb6c8ac87fdf84ba316677f58a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0523c8f8958fdd231931a6dd816ed45a3c9f102ece89bcbd5f3edac0dadc9b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d2f2af595cfb048fcd463d9752779e3fe1ade748a51ecfea86b20e7189261d8"
  end

  depends_on "go" => [:build, :test]

  uses_from_macos "rsync"

  def install
    ldflags = %W[
      -s -w
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.VERSION=#{version}
      -X github.com/bitrise-io/bitrise/v#{version.major}/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bitrise --version")

    (testpath/"bitrise.yml").write <<~YAML
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    YAML

    system bin/"bitrise", "setup"
    system bin/"bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
