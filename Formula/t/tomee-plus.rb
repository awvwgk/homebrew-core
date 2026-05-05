class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-10.1.5/apache-tomee-10.1.5-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-10.1.5/apache-tomee-10.1.5-plus.tar.gz"
  sha256 "e19e2f51cf4f08d4aef427c9391ed9c2ea2e89a24bad983d5abfd18b797135da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4277852f712c4a52ea309ec4b9327c7572ba0f3f0148305864fdf74df63feb4f"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_r(Dir["bin/*.bat"])
    rm_r(Dir["bin/*.bat.original"])
    rm_r(Dir["bin/*.exe"])

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    (bin/"tomee-plus-startup").write_env_script "#{libexec}/bin/startup.sh",
                                                Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Apache TomEE Plus is:
        #{opt_libexec}
      To run Apache TomEE:
        #{opt_libexec}/bin/tomee-plus-startup
    EOS
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
