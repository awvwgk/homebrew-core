class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.36.1.tar.gz"
  sha256 "857843cee905e717d0dd694dd3f5d4b5e12a5064aa95ea61b870d176b9f801aa"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3528313ef8af1c036360d35f2191695ea93a9ea0b6572c465e03b793834550a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3528313ef8af1c036360d35f2191695ea93a9ea0b6572c465e03b793834550a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3528313ef8af1c036360d35f2191695ea93a9ea0b6572c465e03b793834550a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc0ef27e0cad5911923d2d0df4fae3c4ae1a7f0e0c0ea2e19692b9a8efaa4814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eab0b293577f28f9ef920237a76a4186ee74ef76eab8cfc3cbf65a52af912bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e830269f634c9473b4259e80e734cfba84c535cc61498234113e5c80debf7dc1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/resterm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resterm -version")

    (testpath/"openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
        description: A simple test API
      servers:
        - url: https://api.example.com
          description: Production server
      paths:
        /ping:
          get:
            summary: Ping endpoint
            operationId: ping
            responses:
              "200":
                description: Successful response
                content:
                  application/json:
                    schema:
                      type: object
                      properties:
                        message:
                          type: string
                          example: "pong"
      components:
        schemas:
          PingResponse:
            type: object
            properties:
              message:
                type: string
    YAML

    system bin/"resterm", "--from-openapi", testpath/"openapi.yml",
                          "--http-out",     testpath/"out.http",
                          "--openapi-base-var", "apiBase",
                          "--openapi-server-index", "0"

    assert_match "GET {{apiBase}}/ping", (testpath/"out.http").read
  end
end
