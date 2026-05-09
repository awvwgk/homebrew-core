class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-21.0.0.tgz"
  sha256 "24b8facdc853db137d2b1c4932e5db5255f09a00e93571c9363d87fda45a5b23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aeaf26b9dfd40f559b5f92f1764952b21b2b9d56a0efc614d082e14d794b6ba1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove comment to build :all bottle
    node_modules = libexec/"lib/node_modules/commitlint/node_modules"
    inreplace node_modules/"global-directory/index.js", "/opt/homebrew", "HOMEBREW_PREFIX"
  end

  test do
    (testpath/"commitlint.config.js").write <<~JS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    JS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_empty pipe_output(bin/"commitlint", "foo: message")
  end
end
