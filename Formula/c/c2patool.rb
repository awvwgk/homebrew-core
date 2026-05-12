class C2patool < Formula
  desc "CLI for working with C2PA manifests and media assets"
  homepage "https://contentauthenticity.org"
  url "https://github.com/contentauth/c2pa-rs/archive/refs/tags/c2patool-v0.26.58.tar.gz"
  sha256 "10840a5b5ef831c23c3c846b3f5df2bab101baa18dbe925e8b8e809ac1af3edb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/contentauth/c2pa-rs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^c2patool[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d59de2f57111656a68119a780ff940d43898153cf2aca7da221ab4548dd18769"
    sha256 cellar: :any,                 arm64_sequoia: "b994f2dbec4b7cb2600ea89f3ab1a2ec0351f1b67097202bf0021ea2e654dfa9"
    sha256 cellar: :any,                 arm64_sonoma:  "6e95f2a4c4c51ab86a2f678f584cc443517a1cfe60877821dc7e3344ab656a3e"
    sha256 cellar: :any,                 sonoma:        "079fbc334ecf22e4bc322ddf41ce4a86f552eec9afb58dfd4e980923f8839431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b87b11319848ccaec88aa0671046840f55d95527e36fc51c7e7cd4ac42da476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6619a1fc926adfbdd927702309b639f619adb3be90350f8d69faac7954e97e8a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2patool -V").strip

    (testpath/"test.json").write <<~JSON
      {
        "assertions": [
          {
            "label": "com.example.test",
            "data": {
              "my_key": "my_value"
            }
          }
        ]
      }
    JSON

    system bin/"c2patool", test_fixtures("test.png"), "-m", "test.json", "-o", "signed.png", "--force"

    output = shell_output("#{bin}/c2patool signed.png")
    assert_match "\"issuer\": \"C2PA Test Signing Cert\"", output
  end
end
