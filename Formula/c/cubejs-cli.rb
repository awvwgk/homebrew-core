class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.43.tgz"
  sha256 "f391cccb5cca291f783210d4e5a37beb0248b9c454478544f65f3fd5a8d63b1c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1eb0a1b241e9375349d8489665c50dfc909a9cdbe8e74d3fb9e87dcb682fbdd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd91b553f542e4126751ba03fd992f42b29f163fc906c63e35f4e283f030353c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd91b553f542e4126751ba03fd992f42b29f163fc906c63e35f4e283f030353c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cc036f37b4d3e801d5e343ec4fcfd036ac79e3bf0084fe794e37702cc214fa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "415532d66b4d491adaa0eeaac0f012925230c1554f9b2d375fb76df2eefccda5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "415532d66b4d491adaa0eeaac0f012925230c1554f9b2d375fb76df2eefccda5"
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
