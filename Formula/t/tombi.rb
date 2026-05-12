class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "4fcf5c4704b3402813b3d8473c707901a17b8ef457af1f7e433c8cdc916b6095"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99721e7c8ce24225ebd3d34271065837650cbe3ebc99efc7d4d49906a16850a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a92629da7540305a3beee48852dd2c12c026b05f745ee5a1c123c9660f8d460"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18abb308bcecc3ec453b8175bf5bf90db6e80ec56736d404d7464bcba3e175fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "729861d010484a8319237d39fae26ee9ee581f528a8cbe4188a55c0c5ea6c492"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb8a369b61aea9928560c427a25ec165935940a11d6112f9bf3022f025b5bb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93a06315b6caed244ac26d2517ad5a4a07c70f5c046ad83ea8ec53c483f6db19"
  end

  depends_on "rust" => :build

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
