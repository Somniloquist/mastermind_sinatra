require "sinatra"
require "sinatra/reloader" if development?
require "./mastermind.rb"

get '/' do
  erb :index
end