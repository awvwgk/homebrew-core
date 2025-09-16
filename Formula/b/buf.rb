class Buf < Formula
  desc "New way of working with Protocol Buffers"
  homepage "https://github.com/bufbuild/buf"
  url "https://github.com/bufbuild/buf/archive/refs/tags/v1.57.1.tar.gz"
  sha256 "8618be65442d38119ba8cdfe11979a7f3f0849a1d52ee933dcb36b25df0cdad2"
  license "Apache-2.0"
  head "https://github.com/bufbuild/buf.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eedf918e2b786b5897531381334de3308b6653514bbdf17823b4dfa27b867852"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eedf918e2b786b5897531381334de3308b6653514bbdf17823b4dfa27b867852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eedf918e2b786b5897531381334de3308b6653514bbdf17823b4dfa27b867852"
    sha256 cellar: :any_skip_relocation, sonoma:        "c48f3152b75c50bdc0896c4f5a472f0bc66712774c2b4f44fcb199a8723d7937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e39418023f925f3e6a31e2971c9283f75b3bd7694dad725c93c2a4060e8a9e"
  end

  depends_on "go" => :build

  def install
    %w[buf protoc-gen-buf-breaking protoc-gen-buf-lint].each do |name|
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/name), "./cmd/#{name}"
    end

    generate_completions_from_executable(bin/"buf", "completion")
    man1.mkpath
    system bin/"buf", "manpages", man1
  end

  test do
    (testpath/"invalidFileName.proto").write <<~PROTO
      syntax = "proto3";
      package examplepb;
    PROTO

    (testpath/"buf.yaml").write <<~YAML
      version: v1
      name: buf.build/bufbuild/buf
      lint:
        use:
          - STANDARD
          - UNARY_RPC
      breaking:
        use:
          - FILE
        ignore_unstable_packages: true
    YAML

    expected = <<~EOS
      invalidFileName.proto:1:1:Filename "invalidFileName.proto" should be \
      lower_snake_case.proto, such as "invalid_file_name.proto".
      invalidFileName.proto:2:1:Files with package "examplepb" must be within \
      a directory "examplepb" relative to root but were in directory ".".
      invalidFileName.proto:2:1:Package name "examplepb" should be suffixed \
      with a correctly formed version, such as "examplepb.v1".
    EOS
    assert_equal expected, shell_output("#{bin}/buf lint invalidFileName.proto 2>&1", 100)

    assert_match version.to_s, shell_output("#{bin}/buf --version")
  end
end
