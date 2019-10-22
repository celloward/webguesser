require "sinatra"
require "sinatra/reloader"

secret_num = rand(101)

get "/" do
  "The secret number is #{secret_num}"
end