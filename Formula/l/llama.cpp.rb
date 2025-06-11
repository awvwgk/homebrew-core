class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b5630",
      revision: "4c763c8d1b4d4de20bf364ec1837430783cba984"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c4ff0a0364f4f180553e30cc1f3a5a285d7175d39b1df2e76b3a95b7447ea76"
    sha256 cellar: :any,                 arm64_sonoma:  "79ad288fc02930cc38d585c9b2b57584fe31e99f83c8a201c4428f9eea970329"
    sha256 cellar: :any,                 arm64_ventura: "a1ab175b0d8544f1d4581fd50505657ca102f283ffc623133da5dfbd490a7d2e"
    sha256 cellar: :any,                 sonoma:        "ec237c3d75fa6ca17f078a429bacc5e4f40461cdbebc2f86ed65b51dab139727"
    sha256 cellar: :any,                 ventura:       "1c8fe3832af3f1857f435eec86d38a9a1029fc570535cd9c613faf27453bd6f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abb20595906788a1260dca8ef87ef1f4429eaa7e2061065c224a0ffb2b68a440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c945bae1b21a5c8d4cf203d15f4588fe135354c1141174adcf4a8b1885dd6a71"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_CURL=ON
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.children
    bin.install_symlink libexec.children.select { |file|
                          file.executable? && !file.basename.to_s.start_with?("test-")
                        }
  end

  test do
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
