require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rack::Pjax do
  include Rack::Test::Methods # can be moved to config

  def generate_app(options={})
    body = options[:body]

    Rack::Lint.new(
      Rack::Pjax.new(
        lambda do |env|
          [
            200, 
            {'Content-Type' => 'text/plain', 'Content-Length' => Rack::Utils.bytesize(body).to_s}, 
            [body]
          ]
        end
      )
    )
  end

  context "a pjaxified app, upon receiving a pjax-request" do
    before do
      self.class.app = generate_app(:body => '<html><title>Hello</title><body><div data-pjax-container>World!</div></body></html>')
    end

    it "should return the title-tag in the body" do
      get "/", {}, {"HTTP_X_PJAX" => "true"}
      body.should == "<title>Hello</title>World!"
    end

    it "should return the inner-html of the pjax-container in the body" do
      self.class.app = generate_app(:body => '<html><body><div data-pjax-container>World!</div></body></html>')

      get "/", {}, {"HTTP_X_PJAX" => "true"}
      body.should == "World!"
    end

    it "should return the correct Content Length" do
      get "/", {}, {"HTTP_X_PJAX" => "true"}
      headers['Content-Length'].should == Rack::Utils.bytesize(body).to_s
    end

    it "should return the original body when there's no pjax-container" do
      self.class.app = generate_app(:body => '<html><body>Has no pjax-container</body></html>')

      get "/", {}, {"HTTP_X_PJAX" => "true"}
      body.should == "<html><body>Has no pjax-container</body></html>"
    end

    it "should preserve whitespaces of the original body" do
      container = "\n <p>\nfirst paragraph</p> <p>Second paragraph</p>\n"
      self.class.app = generate_app(:body =><<-BODY)
<html>
<div data-pjax-container>#{container}</div>
</html>
BODY

      get "/", {}, {"HTTP_X_PJAX" => "true"}
      body.should == container
    end
  end

  context "a pjaxified app, upon receiving a non-pjax request" do
    before do
      self.class.app = generate_app(:body => '<html><title>Hello</title><body><div data-pjax-container>World!</div></body></html>')
    end

    it "should return the original body" do
      get "/"
      body.should == '<html><title>Hello</title><body><div data-pjax-container>World!</div></body></html>'
    end

    it "should return the correct Content Length" do
      get "/"
      headers['Content-Length'].should == Rack::Utils.bytesize(body).to_s
    end
  end
end
