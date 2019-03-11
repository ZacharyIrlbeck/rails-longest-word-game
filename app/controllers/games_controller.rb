require 'open-uri'
require 'json'
class GamesController < ApplicationController

  def new
    @letters = []
    10.times do
      @letters << ('a'..'z').to_a.sample
    end

    @letters
  end

  def grid?(attempt, grid)
    attempt.downcase.chars.all? { |letter| grid.downcase.count(letter) >= attempt.downcase.count(letter)}
  end


  def score
    @results = {}
    @grid = params[:grid]
    @guess = params[:guess]
    @url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    api_response = JSON.parse(open(@url).read)
    if !api_response["found"]
      @results[:message] = "Not a real word slick"
    elsif grid?(@guess, @grid) && api_response['found']
      @results[:message] = "Fantabulous!"
      # checking to see if score is nil
      if session[:score].nil?
        # if not initialize to the length of the word
        session[:score] = @guess.length
      else
      # else add to the score the length of the word
        session[:score] += @guess.length
      end
      # assign the total score value to score for later display
      @results[:score] = session[:score]
    else
      @results[:message] = "not in grid"
    end
    return @results
  end
end
