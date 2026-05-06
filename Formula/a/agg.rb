class Agg < Formula
  desc "Asciicast to GIF converter"
  homepage "https://github.com/asciinema/agg"
  url "https://github.com/asciinema/agg/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "9a2a7e6ca2748befb6a4c1c3eff437ae6029fde99ec882a951b3671aa30eacdb"
  license "GPL-3.0-or-later"
  head "https://github.com/asciinema/agg.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8fef5f5c8aaa512ef7e23e4b33088bf26cb0d9c07735290e3310c616c1e9620"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3de2ac70d10c237f1a8beaa21d9f97a805d82403069ae7c62ca16bbc1a83163b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e55f7f1a9398d18e9634fe153e9a3ffe4e3844795651b96edbc2172d0964735b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f18b40c39ad6d0403b93e0165cb65475f9538c9b5cf260f862ebd2a035661b4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a08a1101878e748c94279c8be5bce48f207b93dfe9f5654f2e855a9f5030d3af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "494d2a62499dbea334598e2c0c309820af9aa5a3c6ae9d0f6d7c4ca8de18b212"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.cast").write <<~EOS
      {"version": 2, "width": 80, "height": 24, "timestamp": 1504467315, "title": "Demo", "env": {"TERM": "xterm-256color", "SHELL": "/bin/zsh"}}
      [0.248848, "o", "\\u001b[1;31mHello \\u001b[32mWorld!\\u001b[0m\\n"]
      [1.001376, "o", "That was ok\\rThis is better."]
      [2.143733, "o", " "]
      [6.541828, "o", "Bye!"]
    EOS
    system bin/"agg", "--verbose", "test.cast", "test.gif"
    assert_path_exists testpath/"test.gif"
  end
end
