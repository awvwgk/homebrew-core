class Karakeep < Formula
  desc "CLI tool for self-hostable bookmark-everything app karakeep"
  homepage "https://karakeep.app/"
  url "https://registry.npmjs.org/@karakeep/cli/-/cli-0.32.0.tgz"
  sha256 "082164b45ebad1f18fdfac023e6e800170faca2fdb6532a2ebe150758a60a77f"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b524abe2861d0382a75aacfa46276dcebc42971f5d564a49716bb07797f81a47"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/karakeep --version")

    ENV["KARAKEEP_API_KEY"] = "invalid"
    ENV["KARAKEEP_SERVER_ADDR"] = "localhost:#{free_port}"

    assert_match "Error: Failed to query bookmarks", shell_output("#{bin}/karakeep bookmarks list 2>&1")
  end
end
