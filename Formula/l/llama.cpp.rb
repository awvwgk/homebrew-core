class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b9000",
      revision: "1a03cf47f67be591699d1f0f7ca28e1ed6eb8c7e"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `throttle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2bc1cdc7363ff81461ef1b1cd66bc4d3d571c17432e7c6820096e2429aaa2ed6"
    sha256 cellar: :any,                 arm64_sequoia: "cb2fd74a15cccea452e85bc70e61ba555426dcf9661eac3e5be966f6e138b00f"
    sha256 cellar: :any,                 arm64_sonoma:  "7ad418189c5d8aaed7cc3ac21cd6886d561334d7ee249700b99b1688370f4893"
    sha256 cellar: :any,                 sonoma:        "648df174d2190fe52340a390e5ac20fad17708936fbebd5445fc0b80b90ea7b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56b6956c16453fe942341f5741bca6019ea9568ee88c3de162e514067062125f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d1404214c77627e6db23cfc6bb839e5f129d03cec7ebfe53aa454b808681ef0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ggml" # NOTE: reject all PRs that try to bundle ggml
  depends_on "openssl@3"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_BUILD_TESTS=OFF
      -DLLAMA_OPENSSL=ON
      -DLLAMA_USE_SYSTEM_GGML=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/test-sampling.cpp"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      find_package(llama REQUIRED)
      add_executable(test-sampling #{pkgshare}/test-sampling.cpp)
      target_link_libraries(test-sampling PRIVATE llama)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test-sampling"

    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-completion", "--hf-repo", "ggml-org/tiny-llamas",
                                   "-m", "stories260K.gguf",
                                   "-n", "400", "-p", "I", "-ngl", "0"
  end
end
