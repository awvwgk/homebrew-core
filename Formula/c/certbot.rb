class Certbot < Formula
  include Language::Python::Virtualenv

  desc "Tool to obtain certs from Let's Encrypt and autoenable HTTPS"
  homepage "https://certbot.eff.org/"
  url "https://files.pythonhosted.org/packages/14/aa/5d3ba1a90e2cbb74a3a3f8183a95104deaba08b2dbd14a5c7c377cb028b3/certbot-5.5.0.tar.gz"
  sha256 "c72c813c4c8646a9658bc7a9530c757c76067503fa2f5d7eb12027e8bbf798d7"
  license "Apache-2.0"
  revision 1
  head "https://github.com/certbot/certbot.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19815eb8dd87dfcc448ea2ef9c8ec93e153dc45ae9c8391f94675ba48cd05768"
    sha256 cellar: :any,                 arm64_sequoia: "c1e3aa4657a3a0434d63bd9f6481e25d73ef4e79b94c8a36c60935685d7ab5bb"
    sha256 cellar: :any,                 arm64_sonoma:  "63ff3e1b9549d12239104566a41953e0294e74e51ee456986b708706a14d6adf"
    sha256 cellar: :any,                 sonoma:        "8af11601d8486272bbc18e361dd0f29ec55498e3d68ea43db440c01f8e790867"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60f2333e5399f1e7a477bfa6f8fd393352a722d580901201964fcb811e283336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6a99d3c6158311a49961c45d8abddebb1a3a512333a043950af5338f8fa3752"
  end

  depends_on "augeas"
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: ["certifi", "cryptography"],
                extra_packages:   ["certbot-apache", "certbot-nginx", "certbot-dns-cloudflare"]

  resource "acme" do
    url "https://files.pythonhosted.org/packages/18/a2/8dcd9f32e68985c08696c66838c21f3aa42089a510bf96b24ebcb9cd4729/acme-5.5.0.tar.gz"
    sha256 "0c237fe013a5406e9ea8b8bb04d6b753a0ed30005df1315175cb99d9c8f2248d"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "certbot-apache" do
    url "https://files.pythonhosted.org/packages/49/17/9a5d4dfed67d5f07c23d77dd2963f0c6faa7ae09ea6d79ab5514768e3c2e/certbot_apache-5.5.0.tar.gz"
    sha256 "ab5e51821947a547a65f49897b9d1ae508441acc3935c383354c036104259e18"
  end

  resource "certbot-dns-cloudflare" do
    url "https://files.pythonhosted.org/packages/f9/89/e73b675a08f9451429e5c4f325ccaff28ae472b4a6ea88dbcacf1948f268/certbot_dns_cloudflare-5.5.0.tar.gz"
    sha256 "ff3b2d75055b1f31bbedd8801ed654e1da8dc408bdcb158986972eada9312afc"
  end

  resource "certbot-nginx" do
    url "https://files.pythonhosted.org/packages/9d/64/c8f9e1d0cbd148218b41cdf9e2a8e397f413bc5a1a46f527ac9cb8cb60f0/certbot_nginx-5.5.0.tar.gz"
    sha256 "fad8e2c3eb82b31a9e0f142a828c6d5e8da6d7256aebfea2639c8ed20eb92795"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "cloudflare" do
    url "https://files.pythonhosted.org/packages/9b/8f/d3a435435c42d4b05ce2274432265c5890f91f6047e6dab52e50c811a4ea/cloudflare-2.19.4.tar.gz"
    sha256 "3b6000a01a237c23bccfdf6d20256ea5111ec74a826ae9e74f9f0e5bb5b2383f"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/3f/0b/30328302903c55218ffc5199646d0e9d28348ff26c02ba77b2ffc58d294a/configargparse-1.7.5.tar.gz"
    sha256 "e3f9a7bb6be34d66b2e3c4a2f58e3045f8dfae47b0dc039f87bcfaa0f193fb0f"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
  end

  resource "josepy" do
    url "https://files.pythonhosted.org/packages/7f/ad/6f520aee9cc9618d33430380741e9ef859b2c560b1e7915e755c084f6bc0/josepy-2.2.0.tar.gz"
    sha256 "74c033151337c854f83efe5305a291686cef723b4b970c43cfe7270cf4a677a9"
  end

  resource "jsonlines" do
    url "https://files.pythonhosted.org/packages/35/87/bcda8e46c88d0e34cad2f09ee2d0c7f5957bccdb9791b0b934ec84d84be4/jsonlines-4.0.0.tar.gz"
    sha256 "0c6d2c09117550c089995247f605ae4cf77dd1533041d366351f6f298822ea74"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/1a/51/27a5ad5f939d08f690a326ef9582cda7140555180db71695f6fb747d6a36/pyopenssl-26.2.0.tar.gz"
    sha256 "8c6fcecd1183a7fc897548dfe388b0cdb7f37e018200d8409cf33959dbe35387"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/b4/7f/3c194647ecb80ada6937c38a162ab3edba85a8b6a58fa2919405f4de2509/pyrfc3339-2.1.0.tar.gz"
    sha256 "c569a9714faf115cdb20b51e830e798c1f4de8dabb07f6ff25d221b5d09d8d7f"
  end

  resource "python-augeas" do
    url "https://files.pythonhosted.org/packages/44/f6/e09619a5a4393fe061e24a6f129c3e1fbb9f25f774bfc2f5ae82ba5e24d3/python-augeas-1.2.0.tar.gz"
    sha256 "d2334710e12bdec8b6633a7c2b72df4ca24ab79094a3c9e699494fdb62054a10"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    if build.head?
      head_packages = %w[acme certbot certbot-apache certbot-nginx certbot-dns-cloudflare]
      venv = virtualenv_create(libexec, "python3.14")
      venv.pip_install resources.reject { |r| head_packages.include? r.name }
      venv.pip_install_and_link head_packages.map { |pkg| buildpath/pkg }
      pkgshare.install buildpath/"certbot/examples"
    else
      virtualenv_install_with_resources
      pkgshare.install buildpath/"examples"
    end
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/certbot --version 2>&1")
    # This throws a bad exit code but we can check it actually is failing
    # for the right reasons by asserting. --version never fails even if
    # resources are missing or outdated/too new/etc.
    assert_match "Either run as root", shell_output("#{bin}/certbot 2>&1", 1)
  end
end
