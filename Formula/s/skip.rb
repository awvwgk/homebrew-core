class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://github.com/skiptools/skipstone/archive/refs/tags/1.8.14.tar.gz"
  sha256 "34bcc44a0dd55fd52d0a1e62f4acbe8dd7bcb74fe1f2dc1ba1e47b48cf726276"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "45f4ac3868b619d29d2561267ad5f42c67f8fc788d047a267bbc61f0772f5a81"
    sha256                               arm64_sequoia: "9e3cfea11c52af01501f74efbbb3b5e6bb3309c2a7cb97c2acf118ddc745b97f"
    sha256                               arm64_sonoma:  "147dfff8c74d2bde21074d8098fae7d049a64e204216ed2593be80f086f1b54f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6f155513ed0111b06c8e5fe81a5378f1060a76102384623108f9d10aa7ce5a3"
    sha256                               arm64_linux:   "00999a137b9b73fb96d2a35150342c608ec64e690b8491a5c9e39ec5ec381f43"
    sha256                               x86_64_linux:  "56bf605eb13b8e09ac12ed76da23a3ea065ad4785ad516bb2d072e8db68562aa"
  end

  depends_on xcode: :build
  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://github.com/skiptools/skip/archive/refs/tags/1.8.14.tar.gz"
    sha256 "c3a9e8e5b4366e0201e4f9fed6959dcf9d570c502cf38c78c2784c0f7e0b4606"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "SkipRunner"
    bin.install ".build/release/SkipRunner" => "skip"
    generate_completions_from_executable(bin/"skip", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skip version")
    system bin/"skip", "welcome"
    system bin/"skip", "init", "--no-build", "--transpiled-app", "--appid", "some.app.id", "some-app", "SomeApp"
    assert_path_exists testpath/"some-app/Package.swift"
  end
end
