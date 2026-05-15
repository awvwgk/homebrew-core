class Eatmemory < Formula
  desc "Simple program to allocate memory from the command-line"
  homepage "https://github.com/julman99/eatmemory"
  url "https://github.com/julman99/eatmemory/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "02ca26cb30813563075618e1a86f2a63b0f6f3c258e5cd6f287e10ef6468e64f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8cc9da4c3299c442a37a524d9a26ddd49d5d9186af2699bdf672682713e914d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f23c031cd7cfe38611e5ea29acb66a9e744ca48c39469af5bd6c4786015c4db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d73a9cc3aa13cb4044ddf95ecccb802ddbaa2aeb0e102e964644b0de3dcfcb8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fa28eec23bd72543ab4fd2f4f4bf5215a5ec5bd9b294e53c4c175c8f098f179"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab4f27c6a212fb78333d616168bd586c7da08144aeb1db5ae3d8209e19feb17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1de7750bf1eecedb50d212d6e43319cf4fe8a0ff4406b9136c12c3c9422fc73f"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    assert_match "eatmemory #{version}", shell_output("#{bin}/eatmemory --help")

    out = shell_output("#{bin}/eatmemory -t 0 10M")
    assert_match(/^Eating .+ in chunks of .+\.\.\.$/, out)
    assert_match(/^Done, sleeping for 0 seconds before exiting\.\.\.$/, out)

    pid = spawn bin/"eatmemory", "-t", "60", "10M", [:out, :err] => File::NULL
    sleep 5

    rss_kb = shell_output("ps -o rss= -p #{pid}").to_i
    assert_operator rss_kb, :>=, 10 * 1024
    assert_operator rss_kb, :<, 20 * 1024
  ensure
    if pid
      begin
        Process.kill("TERM", pid)
        Process.wait(pid)
      rescue Errno::ESRCH, Errno::ECHILD
        nil
      end
    end
  end
end
