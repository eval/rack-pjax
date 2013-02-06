require 'nokogiri'

module Rack
  class Pjax
    include Rack::Utils

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      return [status, headers, body] unless pjax?(env)

      headers = HeaderHash.new(headers)

      new_body = ""
      body.each do |b|
        b.force_encoding('UTF-8') if RUBY_VERSION > '1.9.0'

        parsed_body = Nokogiri::HTML(b)
        container = parsed_body.at(container_selector(env))

        new_body << begin
          if container
            title = parsed_body.at("title")
            data = parsed_body.css(data_selector(env))
            "%s%s%s" % [title, container.inner_html, data]
          else
            b
          end
        end
      end

      body.close if body.respond_to?(:close)

      headers['Content-Length'] &&= bytesize(new_body).to_s
      headers['X-PJAX-URL'] = Rack::Request.new(env).fullpath

      [status, headers, [new_body]]
    end

    protected
      def pjax?(env)
        env['HTTP_X_PJAX']
      end

      def container_selector(env)
        env['HTTP_X_PJAX_CONTAINER'] || "[@data-pjax-container]"
      end

      def data_selector(env)
        env['HTTP_X_PJAX_DATA'] || "[@data-pjax-data]"
      end
  end
end
