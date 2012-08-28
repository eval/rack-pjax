require 'sinatra'
require "rack/pjax/version"

module Pjax
  class App < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))
    set :root,     "#{dir}/.."
    set :public,   "#{dir}/.."
    set :app_file, __FILE__
    set :views,    "app/views"
    enable :static

    get '/' do
      erb :index
    end

    get '/redirect' do
      redirect '/dinosaurs.html'
    end

    get '/:page.html' do
      erb :"#{params[:page]}"
    end

    helpers do
      def partial(page, options={})
        erb :"_#{page}", options.merge!(:layout => false)
      end
    end
  end
end
