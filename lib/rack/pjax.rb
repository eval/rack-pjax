require 'hpricot'

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
          parsed_body = Hpricot.XML(b)
          container = parsed_body.at(container_selector(env))
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
        headers['X-PJAX-URL'] = env['REQUEST_URI'] if env['REQUEST_URI']
      end
      [status, headers, body]
    end

    protected
      def pjax?(env)
        env['HTTP_X_PJAX']
      end

      def container_selector(env)
        env['HTTP_X_PJAX_CONTAINER'] || "[@data-pjax-container]"
      end
  end
end
