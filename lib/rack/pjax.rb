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

        response.close if response.respond_to?(:close)
        response = [body]

        headers['Content-Length'] &&= bytesize(body).to_s
      end
      [status, headers, response]
    end

    protected
      def pjax?(env)
        env['HTTP_X_PJAX']
      end
  end
end
