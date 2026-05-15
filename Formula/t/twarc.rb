class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/44/1e/b124f63e6b220c0bd85abe062b77809a0cfd2e9e6d8aed25f9069687df5a/twarc-2.14.1.tar.gz"
  sha256 "54537495c6575863769e82ba4a0db7d68538e7c5afa9b8fcc8856a0ae94d9fa0"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "691ed33e9576de03f81a8df02f2aaf80fc3797afebb82fa1d55cfb8a14a73fe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45d92a884dced112f358d36393b91b65b40f3c68011491f4fe8c64ab11d500e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f621b829e25bcc141449d34868534c58c4c84576328c55679da24f755a41ef64"
    sha256 cellar: :any_skip_relocation, sonoma:        "878e60d17db78fd062727a5c0f39350125655ef6065aded16beb0aee25f26535"
    sha256                               arm64_linux:   "2a3665b988fc6dae99aaed6e6cb109845ec810ab9867e82dc1a6963c36eb2f8c"
    sha256                               x86_64_linux:  "3842380a0229bd118f84a0c5e1cbc288cacbf089cc49d3554b3caa3b406743e4"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "numpy" => :no_linkage
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: %w[certifi numpy]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "click-config-file" do
    url "https://files.pythonhosted.org/packages/13/09/dfee76b0d2600ae8bd65e9cc375b6de62f6ad5600616a78ee6209a9f17f3/click_config_file-0.6.0.tar.gz"
    sha256 "ded6ec1a73c41280727ec9c06031e929cdd8a5946bf0f99c0c3db3a71793d515"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/c3/a4/34847b59150da33690a36da3681d6bbc2ec14ee9a846bc30a6746e5984e4/click_plugins-1.1.1.2.tar.gz"
    sha256 "d7af3984a99d243c131aa1a828331e7630f4a88a9741fd05c927b204bcf92261"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/ba/66/a3921783d54be8a6870ac4ccffcd15c4dc0dd7fcce51c6d63b8c63935276/humanize-4.15.0.tar.gz"
    sha256 "1dd098483eb1c7ee8e32eb2e99ad1910baefa4b75c3aff3a82f4d78688993b10"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/a2/f7/139d22fef48ac78127d18e01d80cf1be40236ae489769d17f35c3d425293/more_itertools-11.0.2.tar.gz"
    sha256 "392a9e1e362cbc106a2457d37cabf9b36e5e12efd4ebff1654630e76597df804"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/f8/87/4341c6252d1c47b08768c3d25ac487362bf403f0313ddae4a2a26c9b1b4c/pandas-3.0.3.tar.gz"
    sha256 "696a4a00a2a2a35d4e5deb3fc946641b96c944f02230e4f76137fe35d806c4fc"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/24/36/7180e7f077c38108945dbbdf60fe04db681c3feb6e96419f8c6dc8723741/requests-2.34.1.tar.gz"
    sha256 "0fc5669f2b69704449fe1552360bd2a73a54512dfd03e65529157f1513322beb"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  resource "twarc-csv" do
    url "https://files.pythonhosted.org/packages/33/c5/cabde70e45eeec51b550a2f581d812b3bb7b3f3d01381d31acda1a7963f4/twarc-csv-0.7.2.tar.gz"
    sha256 "8d62f426bd6c7dd0b7848078382ace2e847843e2598fc91b0e88ae42888ec9f4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"twarc2", shell_parameter_format: :click)
  end

  test do
    (testpath/"config").write <<~EOS
      bearer_token = 'test'
    EOS
    assert_match version.to_s, shell_output("#{bin}/twarc2 --config config version")
    assert_match "Unauthorized", shell_output("#{bin}/twarc2 --config #{testpath}/config tweet 123 2>&1")
  end
end
