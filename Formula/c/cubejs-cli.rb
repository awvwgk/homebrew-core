class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.42.tgz"
  sha256 "0e4cee23c9d1c96eb7f26b11615f9f79dd2e1cdb05772f93e014a30d7c83a7ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c15da0e73ffd37559107fc8f0269be7e082b40eb52b2fe4b8d281a5eaa385ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f924a6ec2244422e4a21f58ab10c30abb7c3254786bfdf6fb29baae69d9268c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f924a6ec2244422e4a21f58ab10c30abb7c3254786bfdf6fb29baae69d9268c"
    sha256 cellar: :any_skip_relocation, sonoma:        "400e6d1c34bd7fac42277f7c111c1d35c12cf46893a5356dcaf1643531b8f74d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27de0c1af7939438f0fc44a9487fbcf66f9f1a5054b875674bcf8c8e70fe3268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27de0c1af7939438f0fc44a9487fbcf66f9f1a5054b875674bcf8c8e70fe3268"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end
