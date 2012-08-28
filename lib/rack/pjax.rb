require 'nokogiri'

module Rack
  class Pjax
    include Rack::Utils

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      headers = HeaderHash.new(headers)

      if pjax?(env)
        new_body = ""
        body.each do |b|
          b.force_encoding('UTF-8') if RUBY_VERSION > '1.9.0'
          parsed_body = Nokogiri::HTML(b)
          container = parsed_body.at("[@data-pjax-container]")
          if container
            title = parsed_body.at("title")

            new_body << title.to_s if title
            new_body << container.inner_html
          else
            new_body << b
          end
        end

        body.close if body.respond_to?(:close)
        body = [new_body]

        headers['Content-Length'] &&= bytesize(new_body).to_s
        request = Rack::Request.new(env)
        headers['X-PJAX-URL'] = request.fullpath
      end
      [status, headers, body]
    end

    protected
      def pjax?(env)
        env['HTTP_X_PJAX']
      end
  end
end
