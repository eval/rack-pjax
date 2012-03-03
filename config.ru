$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/app')

require 'pjax'
require 'rack-pjax'

use Rack::Pjax
run Pjax::App.new
