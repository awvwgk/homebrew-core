class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.2.4.tgz"
  sha256 "2eaa85b0dcdc38967d422b0796790f4f6a7bbbc67940ac82f1c564a7fab71ef5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e560572aeabf5fa2bff78e6a08df170b7809be8cda4bb089f230c917f8ecf88"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"context7-mcp", json, 0)
    assert_match "resolve-library-id", output
  end
end
