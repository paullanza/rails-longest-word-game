require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @attempt = params[:attempt]
    @grid = params[:letters].split
    @result = message(@attempt, @grid)
  end

  private

  def valid?(word, grid)
    word.chars.all? do |letter|
      word.count(letter) <= grid.count(letter.upcase)
    end
  end

  def dictionary(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def message(attempt, grid)
    if valid?(attempt, grid)
      if dictionary(attempt)
        "Congrats #{@attempt.upcase} is a valid English word!"
      else
        "Sorry but #{@attempt.upcase} doesn't seem to be an english word."
      end
    else
      "Sorry but #{@attempt.upcase} cant be built out of #{@grid}."
    end
  end
end

# <p>Sorry but <%= @attempt.upcase %> cant be built out of <%= @grid %>.</p>
# <p>Sorry but <%= @attempt.upcase %> doesn't seem to be an english word.</p>
# <p><strong>Congrats!</strong> <%= @attempt.upcase %> is a valid English word!</p>
