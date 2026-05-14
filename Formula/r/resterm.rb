class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.39.2.tar.gz"
  sha256 "033ce48c2203ab4126d00155baf82d55a0f4a3ab2ed0eb3a17229198821bae4c"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c2939b4c717f20b87ce1ab581ceb22de0ecc9096172d576904962bb7f354baf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c2939b4c717f20b87ce1ab581ceb22de0ecc9096172d576904962bb7f354baf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c2939b4c717f20b87ce1ab581ceb22de0ecc9096172d576904962bb7f354baf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f3c7adedef401966f3bbf55b66cede63108aebdcd62598f568d28f5de8d81cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30324a093a443cd355570673103ba334f3d004604e0d288ad7023e38fc373d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c9ea736d0fc0b06fd694da26915d715e62b8a9705ee8087fbdb3c5b38c47a9d"
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
