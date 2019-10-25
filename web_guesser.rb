require "sinatra"
require "sinatra/reloader"

class WebGuesser
  attr_reader :secret_num

  def initialize
    @secret_num = rand(101)
    result = nil
    color = "white"
  end

  def check_guess guess
    @@guesses_left -= 1
    if guess.to_i > @secret_num
      result = "Too high!"
    elsif guess.to_i < @secret_num
      result = "Too low!"
    elsif guess.to_i == @secret_num
      result = "Correct!"
    else
      result = "Not a valid guess. Please enter an integer between 0 and 100"
    end

    if (guess.to_i - @secret_num).abs > 5
      result = "Way " + result.downcase
    else
      result
    end 
  end

  def colorize result
    if result.match(/Correct/)
      color = "green"
    elsif result.match(/Way/)
      color = "red"
    else
      color = "yellow"
    end
  end

  def reset
    @secret_num = rand(101)
    @@guesses_left = 6
    color = "white"
    result = nil
  end
end

@@guesses_left = 6
game = WebGuesser.new

before do
  @secret_num = game.secret_num
end

get "/" do
  guess = params["guess"]
  result = game.check_guess(guess)
  color = game.colorize(result)
  erb :index, :locals => {:secret_num => @secret_num, :result => result, :color => color, :guesses => @@guesses_left}
end

post "/domethod" do
    game.reset
    redirect "/"
end