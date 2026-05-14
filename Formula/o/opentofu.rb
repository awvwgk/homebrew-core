class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.11.8.tar.gz"
  sha256 "5b92c26874620ecc0cf972aba8ef733542ecca86e7ad93b596e11e776ce3eb24"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13de4278fcb1e3c1186c9cba1c2060b2ddf174f353c407cdf16027eac513ab36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4cedf585bd027d68d0fcdffa35ecebf713625f9faed1b73918ece24f1fcd9b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80b2e4884b405ba362c46d95e34ca2809226922e7d7f6aa5d4d1cd39e5520b21"
    sha256 cellar: :any_skip_relocation, sonoma:        "4696d26dd61ac0ee83c3d07c8618c2d1073b43feac32e70fa334a1c3f5f61377"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a2c42b57766a6f586368bbb34b393c70ae52e3ea28afd9a898af22d4a32bcab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3401efb7a795ad155c84ea5106d7d2c1085f223c8bac5a07efd2653684131f7"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X github.com/opentofu/opentofu/version.dev=no"
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags:), "./cmd/tofu"
  end

  test do
    (testpath/"minimal.tf").write <<~HCL
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    HCL

    system bin/"tofu", "init"
    system bin/"tofu", "graph"
  end
end
