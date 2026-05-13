class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.120.0.tar.gz"
  sha256 "59a0b1df599df9411f3f7b8768f9264f4d1527ad625a6ac5de5742c37a3e739c"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3ccb8a347d925cdc0650c1f5655bb6df25dcd4cabd7d1fd7d1c5b343f489378"
    sha256 cellar: :any,                 arm64_sequoia: "95a4c086ccec09b9ac77d8cb7773ad9890adb475f0f72342b9468caabbf80d13"
    sha256 cellar: :any,                 arm64_sonoma:  "ff34b0509dfef56f5b26cb92c92062a4893889d00e8c2ef8bf8f95f92ae1f9a2"
    sha256 cellar: :any,                 sonoma:        "92e397ae6ff041816459d22cbb2a0d9af8ac88b42a7db834918fa8f202cbba4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9414e99d902189ff05466cbf8cb31e36d37a1f8be2e92982e75b781bf233842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7f4c47da8fd2ffcbdf30ea7441b6763adb673788152119d5a1afe77259c523d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "visual-studio-code"

  def openssl = Formula["openssl@4"]

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = openssl.opt_prefix

    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "utils/linkage"

    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")

    linked_libraries = [
      openssl.opt_lib/shared_library("libssl"),
      openssl.opt_lib/shared_library("libcrypto"),
    ]

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"code", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
