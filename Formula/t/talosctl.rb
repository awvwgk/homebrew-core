class Talosctl < Formula
  desc "CLI for out-of-band management of Kubernetes nodes created by Talos"
  homepage "https://www.talos.dev/"
  url "https://github.com/siderolabs/talos/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "61e096008d9e6055d67399e7206db46df6b0320b5f322d4b7a2574fc98368110"
  license "MPL-2.0"
  head "https://github.com/siderolabs/talos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9616002d41d87c1cc400b1ee2319f317c7ee00c499843cdd189a518d69da86d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "548754c1f31ba981b9de9291b330a4e8ab336312d9964a33b3263152c750adb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "167f587c428972c2c16b97ff9348e324cc179bc26d7ce4a6be0c362dbeaf438c"
    sha256 cellar: :any_skip_relocation, sonoma:        "06feddfd17223f0eac811587d0d43d211efca273fbf92c695e88c635867b0c6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3da793d1facd2a042c2806724d686c5ce8548da00cc6f56e1ecb463cdfbc23ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e846bd6c157b677b5194cfe7e18f8d7eb55e523e44c36c84bf2c0c3b228f9c0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/siderolabs/talos/pkg/machinery/version.Tag=#{version}
      -X github.com/siderolabs/talos/pkg/machinery/version.Built=#{time.iso8601}

    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/talosctl"

    generate_completions_from_executable(bin/"talosctl", shell_parameter_format: :cobra)
  end

  test do
    # version check also failed with `failed to determine endpoints` for server config
    assert_match version.to_s, shell_output("#{bin}/talosctl version 2>&1", 1)

    output = shell_output("#{bin}/talosctl list 2>&1", 1)
    assert_match "error constructing client: failed to determine endpoints", output
  end
end
