class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-11.1.2.tgz"
  sha256 "bfe4d2b2c7a3210565bba62929f9efe493eb5f24627201a102ea4514eae8cf80"
  license "MIT"
  compatibility_version 1

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest-11"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b012a98353c5985befa13280bc48551358f9d1113194b4242abb078fdba6059"
    sha256 cellar: :any,                 arm64_sequoia: "ccf429673560480131a32ab8c21b9db2b335037e655ca60346de03cbd11d4ec7"
    sha256 cellar: :any,                 arm64_sonoma:  "ccf429673560480131a32ab8c21b9db2b335037e655ca60346de03cbd11d4ec7"
    sha256 cellar: :any,                 sonoma:        "0162f704a6da76b6a3a536c6e6e1f571bb9b7648dcc09487044b7edf7d112043"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5a7d2d0d2794453a80db1b2fc3757e231f1b6e24008355e211accaaec6174ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5a7d2d0d2794453a80db1b2fc3757e231f1b6e24008355e211accaaec6174ae"
  end

  depends_on "node" => [:build, :test]

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"pnpm", "completion")

    # remove non-native architecture pre-built binaries
    (libexec/"lib/node_modules/pnpm/dist").glob("**/reflink.*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      rm f
    end
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end
