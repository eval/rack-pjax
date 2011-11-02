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
        body.each do |r|
          container = Nokogiri::HTML(r).at_css("[@data-pjax-container]")
          if container
            title = Nokogiri::HTML(r).at_css("title")
            new_body << title.to_s << container.inner_html.strip
          else
            new_body << r
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
