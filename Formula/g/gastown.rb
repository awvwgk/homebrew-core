class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://github.com/steveyegge/gastown/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ddfaf8e774e9f3a281239c04592d04aee10afe621cbfa5df3e29310c9838d753"
  license "MIT"
  head "https://github.com/steveyegge/gastown.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac1982566293568e214523d2d010565eaff2c82041e3ebc5eddbffc39009fca9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac1982566293568e214523d2d010565eaff2c82041e3ebc5eddbffc39009fca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac1982566293568e214523d2d010565eaff2c82041e3ebc5eddbffc39009fca9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1fdd99b90624aae171474e5906cd61673c9630ec5986ac0fe196320ccf0cde1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e8652e28bbed75625a696a9501ffba4dde7a12a82bea1664b98d2098a09502e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69d0a01aa55f5eabb23172c3bc51aa926ec0c4405130e3680832efbce9a2ac6e"
  end

  depends_on "go" => :build
  depends_on "beads"
  depends_on "icu4c@78"

  conflicts_with "genometools", "libslax", because: "both install `gt` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/steveyegge/gastown/internal/cmd.Version=#{version}
      -X github.com/steveyegge/gastown/internal/cmd.Build=#{tap.user}
      -X github.com/steveyegge/gastown/internal/cmd.Commit=#{tap.user}
      -X github.com/steveyegge/gastown/internal/cmd.Branch=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gt"
    bin.install_symlink "gastown" => "gt"

    generate_completions_from_executable(bin/"gt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    system "dolt", "config", "--global", "--add", "user.name", "BrewTestBot"
    system "dolt", "config", "--global", "--add", "user.email", "BrewTestBot@test.com"

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end
