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
        params = Request.new(env).params
        pjax_container = params['_pjax_return'] || '[data-pjax-container]'
        
        new_body = ""
        body.each do |b|
          parsed_body = Hpricot(b)

          container = parsed_body.at("[@#{pjax_container}]")
          if container
            children = container.children
            title = parsed_body.at("title")

            new_body << title.to_s if title
            # workaround hpricot bug (https://github.com/eval/rack-pjax/pull/5)
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
