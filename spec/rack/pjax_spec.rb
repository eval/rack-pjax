require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rack::Pjax do
  include Rack::Test::Methods # can be moved to config

  def app
    Rack::Builder.app do
      use Rack::Pjax
      run lambda { |env|
        body = '<html><title>Hello</title><body><div data-pjax-container>World!</div></body></html>'
        headers = {"Content-Length" => Rack::Utils.bytesize(body).to_s}
        [200, headers, [body]]
      }
    end
  end

  context "when receiving a pjax-request" do
    it "should return title-tag and inner-html of the pjax-container" do
      get "/", {}, {'HTTP_X_PJAX' => true}
      body.should == "<title>Hello</title>World!"
    end

    it "should recalculate the Content Length" do
      get "/", {}, {'HTTP_X_PJAX' => true}
      headers['Content-Length'].should == Rack::Utils.bytesize(body).to_s
    end
  end

  context "when receiving a non-pjax request" do
    it "should not alter the body" do
      get "/"
      body.should == '<html><title>Hello</title><body><div data-pjax-container>World!</div></body></html>'
    end

    it "should have the correct Content Length" do
      get "/"
      headers['Content-Length'].should == Rack::Utils.bytesize(body).to_s
    end
  end
end
