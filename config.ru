require 'rubygems'
require 'rack'
require 'sinatra'

disable :run

set :app_file, 'pinky.rb'
# set :views,    '/full/path/views'

require 'pinky'
run Sinatra::Application
