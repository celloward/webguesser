require "sinatra"
require "sinatra/reloader"

class WebGuesser
  attr_reader :secret_num

  def initialize
    @secret_num = rand(100)
  end

  def sanitize guess
    if guess
      guess.match(/^\d\d?$/) ? guess.to_i : nil 
    end
  end

  def check_guess guess
    result = nil
    if guess && @@guesses_left > 0
      @@guesses_left -= 1  
      if guess > @secret_num
        result = "Too high!"
      elsif guess < @secret_num
        result = "Too low!"
      elsif guess == @secret_num
        result = "Correct!"
      end
      if (guess - @secret_num).abs > 5 
        result = "Way " + result.downcase 
      end
    end
    result
  end

  def colorize result
    if result.nil?
      color = "white"
    elsif result.match(/Correct/)
      color = "green"
    elsif result.match(/Way/)
      color = "red"
    else
      color = "yellow"
    end
  end

  def reset
    @secret_num = rand(100)
    @@guesses_left = 5
    result = nil
  end
end

@@guesses_left = 5
game = WebGuesser.new

before do
  @secret_num = game.secret_num
end

get "/" do
  guess = game.sanitize(params["guess"])
  result = game.check_guess(guess)
  color = game.colorize(result)
  erb :index, :locals => {:secret_num => @secret_num, :result => result, :color => color, :guesses => @@guesses_left}
end

post "/domethod" do
    game.reset
    redirect "/"
end