class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "3c30f3e240ae081617ca14fbe006d3fd768149b1b0b5ae944787e9df1b7bbbdf"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c014bd0a204f53e02c5fe523946bdd4d07174e70e9ac7bc2588d82aabb9f81c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c014bd0a204f53e02c5fe523946bdd4d07174e70e9ac7bc2588d82aabb9f81c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c014bd0a204f53e02c5fe523946bdd4d07174e70e9ac7bc2588d82aabb9f81c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b185c8075fdef935fee97a4a8b6e1ff5496839938c06584b96ef43e225ca2975"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f044c85acf28eb8fb06622077ecb325c6fb0393b5a72411ecfac32817ffe7b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f1aa6f6d8ffe595cd9878f3ad9d269f293631e2b6aa9c08e3661095e3a29e8a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~HCL
      provider "aws" {
        version = "2.39.0"
      }
    HCL

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    assert_match version.to_s, shell_output("#{bin}/tfupdate --version")
  end
end
