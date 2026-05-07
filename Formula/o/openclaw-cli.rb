class OpenclawCli < Formula
  desc "Your own personal AI assistant"
  homepage "https://openclaw.ai/"
  url "https://registry.npmjs.org/openclaw/-/openclaw-2026.5.5.tgz"
  sha256 "c349de6b98d0fac388b0201c039238f6f1f782bb2d1a27cf01480940a3f64d56"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "260ca3c91e37f4901ab48b431177c0a86caec302a59929a28b6faf3a571b5339"
    sha256 cellar: :any,                 arm64_sequoia: "27fd75938586f66c3ae9a7c3ad2da034f310a2f59afff60336e1699e70e9a79f"
    sha256 cellar: :any,                 arm64_sonoma:  "27fd75938586f66c3ae9a7c3ad2da034f310a2f59afff60336e1699e70e9a79f"
    sha256 cellar: :any,                 sonoma:        "9f91460316523d36db11a2fb1869835eb474ab9e152d8444c2f4de27f4823b4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24324b8ba0005748a30a5a2ec0c66367bda7b4f3a356a68c1d7f002dc4aa208a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "059298b86fcaf1f1f3a7519d81c90d8a4e406815c6a49f5b907b557ab4aca738"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/openclaw/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    # sqlite-vec falls back cleanly when the native extension is unavailable.
    # Remove macOS pre-built dylibs that fail Homebrew bottle linkage fixups.
    node_modules.glob("sqlite-vec-darwin-*").each { |dir| rm_r(dir) } if OS.mac?

    # Remove incompatible pre-built binaries (non-native architectures
    # and GPU variants requiring CUDA/Vulkan)
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    target = "#{OS.linux? ? "linux" : "mac"}-#{arch}"

    node_modules.glob("tree-sitter-bash/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != target
    end

    node_modules.glob("@node-llama-cpp/*").each do |dir|
      basename = dir.basename.to_s
      next if basename.start_with?(target) &&
              basename.exclude?("cuda") &&
              basename.exclude?("vulkan")

      rm_r(dir)
    end

    koffi_target = "#{OS.kernel_name.downcase}_#{arch}"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != koffi_target
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openclaw --version")

    output = shell_output("#{bin}/openclaw status")
    assert_match "OpenClaw status", output
  end
end
