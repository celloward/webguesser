require "sinatra"
require "sinatra/reloader"

SECRET_NUM = rand(101)
result = nil

def check_guess guess
  if guess.to_i > SECRET_NUM
    result = "Too high!"
  elsif guess.to_i < SECRET_NUM
    result = "Too low!"
  elsif guess.to_i == SECRET_NUM
    result = "Correct!"
  else
    result = "Not a valid guess. Please enter an integer between 0 and 100"
  end

  if (guess.to_i - SECRET_NUM).abs > 5
    result = "Way " + result.downcase
  else
    result
  end 
end

get "/" do
  guess = params["guess"]
  result = check_guess(guess)
  erb :index, :locals => {:secret_num => SECRET_NUM, :result => result}
end