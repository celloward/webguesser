require "sinatra"
require "sinatra/reloader"

secret_num = rand(101)

get "/" do
  erb :index, :locals => {:secret_num => secret_num}
end