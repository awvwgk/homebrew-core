class Rsyncy < Formula
  desc "Status/progress bar for rsync"
  homepage "https://github.com/laktak/rsyncy"
  url "https://github.com/laktak/rsyncy/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "a19136713aee2242bf702dbd9be7a2deb6a94a001910b9a297e236bb00ccac5e"
  license "MIT"
  head "https://github.com/laktak/rsyncy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce8bfe4b5cf09f2cce0c7a2fe54caf1ebe24918cff5576e512767e100b54f647"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce8bfe4b5cf09f2cce0c7a2fe54caf1ebe24918cff5576e512767e100b54f647"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce8bfe4b5cf09f2cce0c7a2fe54caf1ebe24918cff5576e512767e100b54f647"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a58b48e86714bfa7e0bd72616aa49f3ef084090a1f1f61da9eba3c65dc466cb"
    sha256 cellar: :any_skip_relocation, ventura:       "2a58b48e86714bfa7e0bd72616aa49f3ef084090a1f1f61da9eba3c65dc466cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "280965bc23031ff27e7a031a6234ac15a0e9634de66420c3404d149b3ca45fc9"
  end

  depends_on "go" => :build
  depends_on "rsync"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # rsyncy is a wrapper, rsyncy --version will invoke it and show rsync output
    assert_match(/.*rsync.+version.*/, shell_output("#{bin}/rsyncy --version"))

    # test copy operation
    mkdir testpath/"a" do
      mkdir "foo"
      (testpath/"a/foo/one.txt").write <<~EOS
        testing
        testing
        testing
      EOS
      system bin/"rsyncy", "-r", testpath/"a/foo/", testpath/"a/bar/"
      assert_path_exists testpath/"a/bar/one.txt"
    end
  end
end
