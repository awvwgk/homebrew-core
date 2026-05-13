class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v7.6.0/nuget.exe"
  sha256 "751ee5e79481626a428c1241dc7f94bca2739b32588e669715bc5fb54d8fb8a2"
  license "MIT"

  livecheck do
    url "https://dist.nuget.org/tools.json"
    strategy :json do |json|
      json["nuget.exe"]&.map do |item|
        next if item["stage"] != "ReleasedAndBlessed"

        item["version"]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d25920f1b80f5d0f782d420889669c1c459a7e811fdf81832ace37916cafe0aa"
  end

  depends_on "mono"

  def install
    libexec.install "nuget.exe" => "nuget.exe"
    (bin/"nuget").write <<~BASH
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    BASH
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list packageid:NuGet.Protocol.Core.v3")
  end
end
