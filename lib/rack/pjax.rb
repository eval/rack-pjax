require 'nokogiri'

module Rack
  class Pjax
    include Rack::Utils

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)
      headers = HeaderHash.new(headers)

      if pjax?(env)
        body = ""
        response.each do |r|
          container = Nokogiri::HTML(r).at_css("[@data-pjax-container]")
          if container
            title = Nokogiri::HTML(r).at_css("title")
            body << title.to_s << container.inner_html.strip
          else
            body << r
          end
        end
        response = [body]

        # headers['Content-Length'] &&= Rack::Utils.bytesize(body).to_s
        if headers['Content-Length']
          length = response.to_ary.inject(0) { |len, part| len + bytesize(part) }
          headers['Content-Length'] = length.to_s
        end

      end
      [status, headers, response]
    end

    protected
      def pjax?(env)
        env['HTTP_X_PJAX']
      end
  end
end
