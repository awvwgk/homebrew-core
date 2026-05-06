class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust with ease"
  homepage "https://github.com/tw93/Pake"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-3.11.5.tgz"
  sha256 "ed97ab4850cb2810d8596ddc873f92378b6048e0c609cc43c0699bc2b7079d8c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "047b2a7ad3397975111f84330946d692d2fefc392a7fd0e974517f1a7c815131"
    sha256 cellar: :any,                 arm64_sequoia: "b9f15f1631d652720456009831cb7375fc19bbf22391857236b2c8cdf92effa0"
    sha256 cellar: :any,                 arm64_sonoma:  "b9f15f1631d652720456009831cb7375fc19bbf22391857236b2c8cdf92effa0"
    sha256 cellar: :any,                 sonoma:        "78399aa9766efd7da7e841bd09b5da4166a132051433d399a53cbcc394794a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46aae1f82436b37d5a926b77bba58993349c47f392d0f42eb8b1b2a993c50779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ebf1474e564c9a05b06154da5f5b893b094be91417b39adcba7baa7cb23e234"
  end

  depends_on "node"
  depends_on "pnpm"
  depends_on "rust"
  depends_on "vips"

  # Resources needed to build sharp from source to avoid bundled vips
  # https://sharp.pixelplumbing.com/install/#building-from-source
  resource "node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.7.0.tgz"
    sha256 "06cdc368599c65b996003ac5d71fe594a78d3d94fc51600b2085d5a325a3d930"
  end

  resource "node-gyp" do
    url "https://registry.npmjs.org/node-gyp/-/node-gyp-12.3.0.tgz"
    sha256 "d209963f2b21fd5f6fad1f6341897a98fc8fd53025da36b319b92ebd497f6379"
  end

  def install
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    system "npm", "install", *std_npm_args, *resources.map(&:cached_download)
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/pake-cli/node_modules"
    rm_r(libexec.glob("#{node_modules}/icon-gen/node_modules/@img/sharp-*"))

    libexec.glob("#{node_modules}/.pnpm/fsevents@*/node_modules/fsevents/fsevents.node").each do |f|
      deuniversalize_machos f
    end
  end

  test do
    require "expect"
    assert_match version.to_s, shell_output("#{bin}/pake --version")

    (testpath/"index.html").write <<~HTML
      <h1>Hello, World!</h1>
    HTML

    begin
      io = IO.popen("#{bin}/pake index.html --use-local-file --iterative-build --name test")
      sleep 5
    ensure
      Process.kill("TERM", io.pid)
      Process.wait(io.pid)
    end

    assert_match "No icon provided, using default icon.", io.read
  end
end
