class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.45.tgz"
  sha256 "8f9a5253107f98792969daf1013394700c2394e811c9df4d56c3a2fc9eda3d6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08b4584e0df5911eda6b422b39a4efe6c345f226c826941fa019dbbd42304fb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06dcdf7fcb72f19456124445c76f679132c77afd036b1305950dd78f36d5a43f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06dcdf7fcb72f19456124445c76f679132c77afd036b1305950dd78f36d5a43f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bf30a7f5ed4490722eeecb670142adffa01d90bd70fbbfc7c9752d01dbf168e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efc08dbbca9382abd4642b61431f32ab6e2d9bc3f54667d3207f1365a133c127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efc08dbbca9382abd4642b61431f32ab6e2d9bc3f54667d3207f1365a133c127"
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
