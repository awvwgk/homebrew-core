class Pulledpork < Formula
  desc "Snort rule management"
  homepage "https://github.com/shirkdog/pulledpork"
  url "https://github.com/shirkdog/pulledpork/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "f0149eb6f723b622024295e0ee00e1acade93fae464b9fdc323fdf15e99c388c"
  license "GPL-2.0-or-later"
  head "https://github.com/shirkdog/pulledpork.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6cc19983e6d8418de919dfefbd48de58655b16751cbf82a0a37814d819072d62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "521630afa230a7c06cec0e42ff50663ceb86232c24780d3f26b414a05ce539ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73420470b3baa100fcd93013911028bf923cb110e9ef7a76d5aa3bce5700dd60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c426bbb74ebe2d71cdcc359b5b627d3cee771138be816e22aafcf9bacab773e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c426bbb74ebe2d71cdcc359b5b627d3cee771138be816e22aafcf9bacab773e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d356a368ba34f3ebabf869b9edf2038d962b7cdd661be3317e3b3b68b825c03"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca02edd3b3c9f8520ffb30a7cfec1f73e07dc18c7a85fa769534ce304afb9979"
    sha256 cellar: :any_skip_relocation, ventura:        "9ac992cb245188689c716615660393ff8904ed48b56ddf5d5b36df147274480c"
    sha256 cellar: :any_skip_relocation, monterey:       "9ac992cb245188689c716615660393ff8904ed48b56ddf5d5b36df147274480c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef9c66506c6ac34967fbc3c9bf48ecfc2946814a2dccb3e1fb53f1212e7a3bb1"
    sha256 cellar: :any_skip_relocation, catalina:       "deaaf558752aa6c864008dbf4cd058850d4206f5e97b50bc6e1f5b2706694fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4e4bc594fcded62faba1a9dbc1003b161d8eca7007a19245833d888010d17026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f925daf30d6bdfa68a3d8ebf2e2d0fef9a069aa14cd6d45c2b1e41b72665acdd"
  end

  uses_from_macos "perl"

  on_linux do
    resource "LWP::UserAgent" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.83.tar.gz"
      sha256 "e75f0fa9d3c6f0daf5a5a72fa9f8b1c9c0d23e3a84a8522ccb4f835232b95505"
    end

    resource "HTML::HeadParser" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTML-Parser-3.83.tar.gz"
      sha256 "7278ce9791256132b26a71a5719451844704bb9674b58302c3486df43584f8c0"
    end

    resource "HTML::Tagset" do
      url "https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.24.tar.gz"
      sha256 "eb89e145a608ed1f8f141a57472ee5f69e67592a432dcd2e8b1dbb445f2b230b"
    end

    resource "HTTP::Headers" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Message-7.01.tar.gz"
      sha256 "82b79ce680251045c244ee059626fecbf98270bed1467f0175ff5ea91071437e"
    end

    resource "Clone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/Clone-0.50.tar.gz"
      sha256 "f9732a4a857974db30905233589113003301b585b0cecda29a21cfba5bb014f9"
    end

    resource "LWP::MediaTypes" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/LWP-MediaTypes-6.04.tar.gz"
      sha256 "8f1bca12dab16a1c2a7c03a49c5e58cce41a6fec9519f0aadfba8dad997919d9"
    end

    resource "HTTP::Date" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Date-6.06.tar.gz"
      sha256 "7b685191c6acc3e773d1fc02c95ee1f9fae94f77783175f5e78c181cc92d2b52"
    end

    resource "Time::Zone" do
      url "https://cpan.metacpan.org/authors/id/A/AT/ATOOMIC/TimeDate-2.35.tar.gz"
      sha256 "baddd0306ae2e86e9ec28d3de5439e514643e80b3735e43bd0fbb426d73304de"
    end

    resource "URI" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.34.tar.gz"
      sha256 "de64c779a212ff1821896c5ca2bb69e74767d2674cee411e777deea7a22604a8"
    end

    resource "MIME::Base32" do
      url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/MIME-Base32-1.303.tar.gz"
      sha256 "ab21fa99130e33a0aff6cdb596f647e5e565d207d634ba2ef06bdbef50424e99"
    end

    resource "Encode::Locale" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/Encode-Locale-1.05.tar.gz"
      sha256 "176fa02771f542a4efb1dbc2a4c928e8f4391bf4078473bd6040d8f11adb0ec1"
    end

    resource "IO::HTML" do
      url "https://cpan.metacpan.org/authors/id/C/CJ/CJM/IO-HTML-1.004.tar.gz"
      sha256 "c87b2df59463bbf2c39596773dfb5c03bde0f7e1051af339f963f58c1cbd8bf5"
    end

    resource "File::Listing" do
      url "https://cpan.metacpan.org/authors/id/P/PL/PLICEASE/File-Listing-6.16.tar.gz"
      sha256 "189b3a13fc0a1ba412b9d9ec5901e9e5e444cc746b9f0156d4399370d33655c6"
    end

    resource "HTTP::Negotiate" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/HTTP-Negotiate-6.01.tar.gz"
      sha256 "1c729c1ea63100e878405cda7d66f9adfd3ed4f1d6cacaca0ee9152df728e016"
    end

    resource "Try::Tiny" do
      url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/Try-Tiny-0.32.tar.gz"
      sha256 "ef2d6cab0bad18e3ab1c4e6125cc5f695c7e459899f512451c8fa3ef83fa7fc0"
    end

    resource "Net::HTTP" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/Net-HTTP-6.24.tar.gz"
      sha256 "290ed9a97b05c7935b048e6d2a356035871fca98ad72c01c5961726adf85c83c"
    end

    resource "WWW::RobotRules" do
      url "https://cpan.metacpan.org/authors/id/G/GA/GAAS/WWW-RobotRules-6.02.tar.gz"
      sha256 "46b502e7a288d559429891eeb5d979461dd3ecc6a5c491ead85d165b6e03a51e"
    end

    resource "HTTP::Cookies" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/HTTP-Cookies-6.11.tar.gz"
      sha256 "8c9a541a4a39f6c0c7e3d0b700b05dfdb830bd490a1b1942a7dedd1b50d9a8c8"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    chmod 0755, "pulledpork.pl"
    bin.install "pulledpork.pl"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
    doc.install Dir["doc/*"]
    (etc/"pulledpork").install Dir["etc/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulledpork.pl -V")
  end
end
