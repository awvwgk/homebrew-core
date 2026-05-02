class Beancount < Formula
  include Language::Python::Virtualenv

  desc "Double-entry accounting tool that works on plain text files"
  homepage "https://beancount.github.io/"
  url "https://files.pythonhosted.org/packages/f8/9d/aa97bb5d354cc853faca60d0b0bf0728af11300cd6276769314885b4b9a8/beancount-3.2.2.tar.gz"
  sha256 "7f9a3919152232c262c826998fb2620046b47249624c665d79fa4b0a72f78bfc"
  license "GPL-2.0-only"
  head "https://github.com/beancount/beancount.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3045ff72fe59dd3077e08f18d541b91421d5fdb08d1b0bbaf154418840685dae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cbfdba20bcae6f4bd7c5c526a32a3369b037bad2491cc35e20a8e04a1881c5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b41451840d2ed0b79e7d7e32799e776001e9a0355525f584ef18f9231a64474"
    sha256 cellar: :any_skip_relocation, sonoma:        "96a14578b71603bb20ebf8f08e4a11fc8dcfde165d0e7ae9ace5c29cd80a36f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e84599c4925de97bd2feb7e75162a9fe8e332bdb0e9b8d79954f73947dc40bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f5e096016de0cfda9bbab51edfec9b71b4b888a135572ee61fd3d46245e287"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "certifi"
  depends_on "python@3.14"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: "certifi"

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/cb/0e/3a246dbf05666918bd3664d9d787f84a9108f6f43cc953a077e4a7dfdb7e/regex-2026.4.4.tar.gz"
    sha256 "e08270659717f6973523ce3afbafa53515c4dc5dcad637dc215b6fd50f689423"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    # Skip the PyPI flex/bison wrappers; we already provide system equivalents.
    inreplace "pyproject.toml", /^\s*'(flex|bison)-bin.*\n/, ""

    virtualenv_install_with_resources

    bin.glob("bean-*") do |executable|
      generate_completions_from_executable(executable, shell_parameter_format: :click)
    end
  end

  test do
    (testpath/"example.ledger").write shell_output("#{bin}/bean-example").strip
    assert_empty shell_output("#{bin}/bean-check #{testpath}/example.ledger").strip
  end
end
