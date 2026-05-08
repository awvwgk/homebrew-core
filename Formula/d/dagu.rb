class Dagu < Formula
  desc "Lightweight and powerful workflow engine"
  homepage "https://dagu.sh"
  url "https://github.com/dagu-org/dagu/archive/refs/tags/v2.6.7.tar.gz"
  sha256 "8ea818a55cdb3fd7dfabf844669e59f4c764d1c502448b49bf0efd18c68febf6"
  license "GPL-3.0-only"
  head "https://github.com/dagu-org/dagu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6de392e671afaeff1e7a753848e457eea9724264f5cbe03e5eac10d354cfe2b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23b92ee45246bf6836bc8856b6599077f094892611731b5ee9a96c80dbea9deb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b2e8c65e94d44efbe52b9469276300bdafea80e4a3fcb1eba74dbb30c23fb6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "02d867b4a3001a3b30c39a63632854996ac841f18f5c8df77413dc049e1add99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5f1a7f8094e657b5b1d00950232ede08d8b84a46d6871f53d6404c53cdb4f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4b309995b4c7d694ca9cf4d55ec06654033d4d0f19e83efe544fef1473b0f78"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "--dir=ui", "install", "--frozen-lockfile"
    system "pnpm", "--dir=ui", "run", "build"
    (buildpath/"internal/service/frontend/assets").install (buildpath/"ui/dist").children

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
    generate_completions_from_executable(bin/"dagu", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"dagu", "start-all"]
    keep_alive true
    error_log_path var/"log/dagu.log"
    log_path var/"log/dagu.log"
    working_dir var
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dagu version 2>&1")

    (testpath/"hello.yaml").write <<~YAML
      steps:
        - name: hello
          command: echo "Hello from Dagu!"

        - name: world
          command: echo "Running step 2"
    YAML

    system bin/"dagu", "start", "hello.yaml"
    shell_output = shell_output("#{bin}/dagu status hello.yaml")
    assert_match "Result: Succeeded", shell_output
  end
end
