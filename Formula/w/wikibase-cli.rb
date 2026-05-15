class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://codeberg.org/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-20.1.2.tgz"
  sha256 "0460e6572ffe6f57ff89f270508b54a821308175b8c84da9d78f7511d79068ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ce87facf80882631c1fd3fbaf692eca2e6dbe15f2a26d4c527ec550400f2124"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    config_file = testpath/".wikibase-cli.json"
    config_file.write "{\"instance\":\"https://www.wikidata.org\"}"

    ENV["WB_CONFIG"] = config_file

    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip

    assert_match version.to_s, shell_output("#{bin}/wd --version")
  end
end
