class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/refs/tags/0.6.55.tar.gz"
  sha256 "76bb69d4d004f8465f13bd4abe50f22afed8205c6fa675d411b583448440df12"
  license "Apache-2.0"
  head "https://github.com/fnproject/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4777caaf7058f5437ca3c26001dc2b6b79857c89d4838c842fa74312d9bfaf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4777caaf7058f5437ca3c26001dc2b6b79857c89d4838c842fa74312d9bfaf1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4777caaf7058f5437ca3c26001dc2b6b79857c89d4838c842fa74312d9bfaf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "30c24254b98cecbf6cefc81d97c1889e5782b3cdf81063baa193a2559ba3232b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c384d073ca7b4b209c2037a0f2486f9857a24d9ecf9c7a12647afd92ac8f69d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af41338a14370378a2dc3c771a70d44d001dd4b9b119c865b93c1b3eb3e22fc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system bin/"fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_path_exists testpath/"func.go", "expected file func.go doesn't exist"
    assert_path_exists testpath/"func.yaml", "expected file func.yaml doesn't exist"
    port = free_port
    server = TCPServer.new("localhost", port)
    pid = fork do
      loop do
        response = {
          id:         "01CQNY9PADNG8G00GZJ000000A",
          name:       "myapp",
          created_at: "2018-09-18T08:56:08.269Z",
          updated_at: "2018-09-18T08:56:08.269Z",
        }.to_json

        socket = server.accept
        socket.gets
        socket.print "HTTP/1.1 200 OK\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end
    sleep 1
    begin
      ENV["FN_API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "Successfully created app:  myapp"
      output = shell_output("#{bin}/fn create app myapp")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
