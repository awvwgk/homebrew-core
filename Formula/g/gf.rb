class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "9bb1cac58cced9a8efe922f90401bffe05d5bb3f6f72917a617a292963a58e54"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b1f882567791f6c99ae4950e69c58b595c3577b46c887ae4330d3dd7b4399e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b1f882567791f6c99ae4950e69c58b595c3577b46c887ae4330d3dd7b4399e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b1f882567791f6c99ae4950e69c58b595c3577b46c887ae4330d3dd7b4399e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "607bda40cd9da6f540e3cd9c7d3caddd01504c7c90b8765cd676734d9543a741"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b15b2a62fd6b230fbce2f0a50d17cd5032b3fb39e3c8e6449ac411eb9d9ac5d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c6e71f4fbc1acc4615cb221e7870878fec5cdc51c2d83458b50b941cc0a6cdf"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
