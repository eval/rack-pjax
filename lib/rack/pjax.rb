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
          parsed_body = Hpricot(b)
          container = parsed_body.at("[@data-pjax-container]")
          if container
            children = container.children
            title = parsed_body.at("title")

            new_body << title.to_s if title
            new_body << children.map { |c| c.to_original_html }.join
          else
            new_body << b
          end
        end

        body.close if body.respond_to?(:close)
        body = [new_body]

        headers['Content-Length'] &&= bytesize(new_body).to_s
      end
      [status, headers, body]
    end

    protected
      def pjax?(env)
        env['HTTP_X_PJAX']
      end
  end
end
