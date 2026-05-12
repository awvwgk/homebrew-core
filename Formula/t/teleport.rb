class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v18.8.0.tar.gz"
  sha256 "13a09c342f2dccdc615471ff0f9be86149f96883662ac3bd685cb2115243068c"
  license all_of: ["AGPL-3.0-or-later", "Apache-2.0"]
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version,
  # so we can't use the `GithubLatest` strategy. We use the `GithubReleases`
  # strategy instead of `Git` because there is often a notable gap (days)
  # between when a version is tagged and released.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f9748ed0d188e32e9329256a434266a89ec993b9f3c19b155815e13261701bd5"
    sha256 cellar: :any,                 arm64_sequoia: "df4c38d34a915de5b955a567b5cd8308bc9bd0313f731102d98b7b24986d6c11"
    sha256 cellar: :any,                 arm64_sonoma:  "7f39eed56893019b2ddcfb02bbd7acfdc44ff7b48de4066149dc33f1f44a91df"
    sha256 cellar: :any,                 sonoma:        "24af4fbf4e20ec53cc48184ba06f05b8e3e0fe9bbab04316af8773cd1b648273"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c67421ec8b392de8dc43f341996372e523824938faed2f59527aefc71ccf753d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3769db5d1fc52e077f6deacb2adf7eb50ef2856d78abb4da4205521e748f0116"
  end

  depends_on "binaryen" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  # TODO: try to remove rustup dependancy, see https://github.com/Homebrew/homebrew-core/pull/191633#discussion_r1774378671
  depends_on "rustup" => :build
  depends_on "libfido2"
  depends_on "openssl@3"

  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"
  conflicts_with cask: "teleport-suite"
  conflicts_with cask: "teleport-suite@17"
  conflicts_with cask: "teleport-suite@16"
  conflicts_with cask: "tsh", because: "both install `tsh` binaries"

  resource "wasm-bindgen" do
    url "https://github.com/wasm-bindgen/wasm-bindgen/archive/refs/tags/0.2.99.tar.gz"
    sha256 "1df06317203c9049752e55e59aee878774c88805cc6196630e514fa747f921f2"

    livecheck do
      url "https://raw.githubusercontent.com/gravitational/teleport/refs/tags/v#{LATEST_VERSION}/Cargo.lock"
      regex(/name\s*=\s*"wasm-bindgen".*?version\s*=\s*["'](\d+(?:\.\d+)+)["']/im)
    end
  end

  # disable `wasm-opt` for ironrdp pkg release build, upstream pr ref, https://github.com/gravitational/teleport/pull/50178
  patch :DATA

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    # Prevent pnpm from downloading another copy due to `packageManager` feature
    (buildpath/"pnpm-workspace.yaml").append_lines <<~YAML
      managePackageManagerVersions: false
    YAML

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    resource("wasm-bindgen").stage do
      system "cargo", "install", *std_cargo_args(path: "crates/cli", root: buildpath)
    end

    # Replace wasm-bindgen binary call to the built one
    inreplace "Makefile", "wasm-bindgen target", buildpath/"bin/wasm-bindgen target"

    # Workaround for error: The CPU Jitter random number generator must not be compiled with optimizations.
    # Issue ref: https://github.com/aws/aws-lc-rs/issues/1097
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"

    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~YAML
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    YAML

    spawn bin/"teleport", "start", "--roles=proxy,node,auth", "--config=#{testpath}/config.yml"
    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl status --config=#{testpath}/config.yml")
    assert_match(/Cluster:\s*testhost/, status)
    assert_match(/Version:\s*#{version}/, status)
  end
end

__END__
diff --git a/web/packages/shared/libs/ironrdp/Cargo.toml b/web/packages/shared/libs/ironrdp/Cargo.toml
index ddcc4db..913691f 100644
--- a/web/packages/shared/libs/ironrdp/Cargo.toml
+++ b/web/packages/shared/libs/ironrdp/Cargo.toml
@@ -7,6 +7,9 @@ publish.workspace = true
 
 # See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html
 
+[package.metadata.wasm-pack.profile.release]
+wasm-opt = false
+
 [lib]
 crate-type = ["cdylib"]
