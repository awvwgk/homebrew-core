class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "54859e9d9517b2df1f0149bf9a0ac91e8d4874a1854b79f252c99a8bfce68392"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ec10e5e212aa6624d8bb06a0b2e84bc3f2977e4c2ea9da8f170a0aaa517a729"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55dda9c780b0a7e48404c592625e5262886c16a05e5680d6b14239562c1047b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6314dbd565192f62debac33789231a4f686ea1033e07416ed49168d3c5da6aef"
    sha256 cellar: :any_skip_relocation, sonoma:        "64e7766f728d7ee486802355aa57878102db2ac27caa601e8b4cad3dd173786d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3fa0da846afebd297e43382891a9ff325ec027003e0cb71a13889a7d8d2301c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d88919ca6899fb45dab2812b71704676e088df0341771fa7ebb5286ed76351"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/arf-console")

    generate_completions_from_executable(bin/"arf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arf --version")

    system bin/"arf", "config", "init"
    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/arf/arf.toml"
    else
      assert_path_exists testpath/".config/arf/arf.toml"
    end
    system bin/"arf", "config", "check"

    assert_match "history", shell_output("#{bin}/arf history schema")
    assert_match "sessions", shell_output("#{bin}/arf ipc list")
  end
end
