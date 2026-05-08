class Goimports < Formula
  desc "Go formatter that additionally inserts import statements"
  homepage "https://pkg.go.dev/golang.org/x/tools/cmd/goimports"
  url "https://github.com/golang/tools/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "1763e56760a51f25ddf1e73cc8ada35c3f81f2fa1094b6118acaa8ec5a51a146"
  license "BSD-3-Clause"
  head "https://github.com/golang/tools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b500cae936bed5e7e7c4aae4adbfa0e0aa752cad795ba2f925dda04a03fe022c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b500cae936bed5e7e7c4aae4adbfa0e0aa752cad795ba2f925dda04a03fe022c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b500cae936bed5e7e7c4aae4adbfa0e0aa752cad795ba2f925dda04a03fe022c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fbf24c08b514634bf3e1158763cc19745d7121becfe0c146df37624518e91cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e95e706c3adc6ee39f21cdec2afc6e8c65fdf519811252ce759ca238e0392844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "146647608b1e17cd9fdfedb44c2e088f25cccbf11865cbabd54f25b29c87970a"
  end

  depends_on "go"

  def install
    chdir "cmd/goimports" do
      system "go", "build", *std_go_args
    end
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      func main() {
        fmt.Println("hello")
      }
    GO

    assert_match(/\+import "fmt"/, shell_output("#{bin}/goimports -d #{testpath}/main.go"))
  end
end
