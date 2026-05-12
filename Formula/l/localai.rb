class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "7a6a772fb35ebe1f334c484434e3479ad4ffe59d4d3c5932002f5d025768bcc1"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "940e3c03ced27bc2450db6ab4ad8470ebdb215cf59b8adb9543904f131aa7248"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfe5c8cb40bea6c720c6cee92a9b970a8f1883a3cf766bb58ea4e41359ec72cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "512cbf65618328b813f752bd9c7f8d80f2df10b19034dff9f996c26931e4878f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c72fb59861c9c890965b6d09e7629a5fe37a9ac6bae37d83702b21517dac1dfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11f95b72e1bf270acfcd5a6a60dd54899bdda5f8d834cbdcfb41759992125331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dde1a0ad6622dc9713e10afc786cfa1967c6395b50438daa117aee14b2542657"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "protobuf" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "protoc-gen-go-grpc" => :build

  def install
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?

    system "make", "build", "VERSION=#{version}"
    bin.install "local-ai"
  end

  test do
    addr = "127.0.0.1:#{free_port}"

    pid = spawn bin/"local-ai", "run", "--address", addr
    sleep 5
    sleep 20 if OS.mac? && Hardware::CPU.intel?

    begin
      response = shell_output("curl -s -i #{addr}/readyz")
      assert_match "HTTP/1.1 200 OK", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
