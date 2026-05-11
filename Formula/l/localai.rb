class Localai < Formula
  desc "OpenAI alternative"
  homepage "https://localai.io"
  url "https://github.com/mudler/LocalAI/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "380d9db879f3c973ffc0d1efd9e8bb503299ade8479ee72b9a6419b1e99378cf"
  license "MIT"
  head "https://github.com/mudler/LocalAI.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f450d770c8230702f07294062e201aa745f93647a732d22c958c86f9b310989"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6765df3004a1993f81db5cad09c8be754860d131d899378ddebe0d21b7905f54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22702cb5ec3850e1ced17e6f5dd455857f5f8cce53bf8d669031a29583d33170"
    sha256 cellar: :any_skip_relocation, sonoma:        "50f42e6c7959604240b6f6476d66065ce683a51fcf5f8a59db5ba04a4cb5b3aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d12ad905172a8e4132dbbee517657bd6d7c4a23d8988c507b114b2061838994f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c5b0d37e8c92143c634c2323f999e927f0ed4f00562e34b006e0832315e74cc"
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
