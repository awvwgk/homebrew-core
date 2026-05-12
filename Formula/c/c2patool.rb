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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "344fe29736f9d2001df72ed0795c292bfafe0391d853894042a89f48625426e6"
    sha256 cellar: :any,                 arm64_sequoia: "3c7e9b8efcf55d1e98912b5c26fd14c0981d2d99048e08c1e4eda721ca424441"
    sha256 cellar: :any,                 arm64_sonoma:  "3cd14d9abb25f26d7a5910487118a05ae27aefa1d28fab3d60dfcd399859af72"
    sha256 cellar: :any,                 sonoma:        "389583077b78dc93336a82d931120f52b313de7e3ab72f2559d07363bd244268"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ec83df3b35576971718048fbf3f86cb759b8f751b54852634f4ba00bfd657f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb03f5415de3e20f57862bd0f0117069c2fda5732dcf7ce93afb106c03f6dba"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
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
