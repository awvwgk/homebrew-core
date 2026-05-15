class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.6.2.tgz"
  sha256 "bb420fbdaf5c7d10505c5c5636b3890123b01ed5c71b97e1206a361c14fd6410"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1646e79917e3204fae8d8fb704d9376303640e54f44b84d89879fd0fddd720c"
    sha256 cellar: :any,                 arm64_sequoia: "39daa1c3dbf88fd42fc2da3476f24b0f22df9a8a26bba7e3945ff7cf773f2f1b"
    sha256 cellar: :any,                 arm64_sonoma:  "39daa1c3dbf88fd42fc2da3476f24b0f22df9a8a26bba7e3945ff7cf773f2f1b"
    sha256 cellar: :any,                 sonoma:        "45ab8a991362ceeaa8c4c9cb097996bd820c191181df57ec83f49c30c3ca51b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aef3bc5eb0906880989651d043178c96221c1d5417e32729b50b1fae297247b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b11dcc2aa3ece8caafa5c82b4a6d37f686e7000ffb2e90d021cc43b087c9655"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/mcp-server-kubernetes/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"mcp-server-kubernetes", json, 0)
    assert_match "kubectl_get", output
    assert_match "kubectl_describe", output
    assert_match "kubectl_logs", output
  end
end
