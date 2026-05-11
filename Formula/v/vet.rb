class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "da54d9d4c5c074f1903ebf61ce385f5fb9e55889df2d86d6d273fbf586ca1a03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c71109481c504035c68027741ccbc6429106ea98c2fad2493ca20cd6eb25d12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2936e20f65edec113f776f4bf5ceb4bfdc28c5c99a4b96dd160a44cecb5ce7db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "118e9a036d5c2cb58250f5f715fa183b340089bf1c742787fc674389fa85e3a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df76bd11c234a9884770480b0130e41a0c9ec99bcf5effdeb608ed8b235aa4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2d16b96f38a90ccad3f87434b11ff10ae023256f31ecbfde935ebb1063c435d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12944980c2defd95fcc55b3aaec3a9fe59221fdff8b3979937293826820250c8"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
