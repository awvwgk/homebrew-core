class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.25.5.tgz"
  sha256 "feb90a87297457608b7d37b3135ea8e1e4a28718c365ceda5251eed7e97d51fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1da7cbcbeb4b016eaae164419ed2c8d5a819372e2bedd6f1e7acf3ee62707218"
    sha256 cellar: :any,                 arm64_sequoia: "9049f7870c2fa2a9fe19c8990b946e7bb5fadc15c4237f74fa3d1436a35b1fd6"
    sha256 cellar: :any,                 arm64_sonoma:  "9049f7870c2fa2a9fe19c8990b946e7bb5fadc15c4237f74fa3d1436a35b1fd6"
    sha256 cellar: :any,                 sonoma:        "c10d34b5a555a8315d1a443d27861518627f6a2094a1d65322e6b11bb46cdc7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af622b2223dca6e48583aabaaf9a32aa17af4af5224fbbe250d05269ff233ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe63e3ffe07bd45aa157bafd8f785a7b343ef6584730bf085240041067f0eb5c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end
