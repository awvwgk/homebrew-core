class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "https://druid.apache.org/"
  url "https://dlcdn.apache.org/druid/24.0.2/apache-druid-24.0.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/druid/24.0.2/apache-druid-24.0.2-bin.tar.gz"
  sha256 "0313ba91d48347c3f94820f8271eda6a18382a526100710a261ccc52ec93a0a5"
  license "Apache-2.0"

  livecheck do
    url "https://druid.apache.org/downloads.html"
    regex(/href=.*?druid[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f4a5c9ec3cac0f9961e57d0fb1930c29f2bf3f5ba5c39678f85750ebac3ed69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f4a5c9ec3cac0f9961e57d0fb1930c29f2bf3f5ba5c39678f85750ebac3ed69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f4a5c9ec3cac0f9961e57d0fb1930c29f2bf3f5ba5c39678f85750ebac3ed69"
    sha256 cellar: :any_skip_relocation, ventura:        "7cba6fc2ac0794c197966a043b7be94191e31d4ccdef4060f7573581a7ba6b89"
    sha256 cellar: :any_skip_relocation, monterey:       "7cba6fc2ac0794c197966a043b7be94191e31d4ccdef4060f7573581a7ba6b89"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cba6fc2ac0794c197966a043b7be94191e31d4ccdef4060f7573581a7ba6b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f4a5c9ec3cac0f9961e57d0fb1930c29f2bf3f5ba5c39678f85750ebac3ed69"
  end

  depends_on "zookeeper" => :test
  depends_on "openjdk@11"

  resource "mysql-connector-java" do
    url "https://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.49/mysql-connector-java-5.1.49.jar"
    sha256 "5bba9ff50e5e637a0996a730619dee19ccae274883a4d28c890d945252bb0e12"
  end

  def install
    libexec.install Dir["*"]

    %w[
      broker.sh
      coordinator.sh
      historical.sh
      middleManager.sh
      overlord.sh
    ].each do |sh|
      inreplace libexec/"bin/#{sh}", "./bin/node.sh", libexec/"bin/node.sh"
    end

    inreplace libexec/"bin/node.sh" do |s|
      s.gsub! "nohup $JAVA", "nohup $JAVA -Ddruid.extensions.directory=\"#{libexec}/extensions\""
      s.gsub! ":=lib", ":=#{libexec}/lib"
      s.gsub! ":=conf/druid", ":=#{libexec}/conf/druid"
      s.gsub! ":=${WHEREAMI}/log", ":=#{var}/druid/log"
      s.gsub! ":=var/druid/pids", ":=#{var}/druid/pids"
    end

    resource("mysql-connector-java").stage do
      (libexec/"extensions/mysql-metadata-storage").install Dir["*"]
    end

    bin.install Dir["#{libexec}/bin/*.sh"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("11")

    Pathname.glob("#{bin}/*.sh") do |file|
      mv file, bin/"druid-#{file.basename}"
    end
  end

  def post_install
    %w[
      druid/hadoop-tmp
      druid/indexing-logs
      druid/log
      druid/pids
      druid/segments
      druid/task
    ].each do |dir|
      (var/dir).mkpath
    end
  end

  test do
    ENV["DRUID_CONF_DIR"] = libexec/"conf/druid/single-server/nano-quickstart"
    ENV["DRUID_LOG_DIR"] = testpath
    ENV["DRUID_PID_DIR"] = testpath
    ENV["ZOO_LOG_DIR"] = testpath

    system Formula["zookeeper"].opt_bin/"zkServer", "start"
    begin
      pid = fork { exec bin/"druid-broker.sh", "start" }
      sleep 40
      output = shell_output("curl -s http://localhost:8082/status")
      assert_match "version", output
    ensure
      system bin/"druid-broker.sh", "stop"
      # force zookeeper stop since it is sometimes still alive after druid-broker.sh finishes
      system Formula["zookeeper"].opt_bin/"zkServer", "stop"
      Process.wait pid
    end
  end
end
