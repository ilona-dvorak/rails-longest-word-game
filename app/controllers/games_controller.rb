require 'json'
require 'open-uri'

class GamesController < ApplicationController

  VOW = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOW.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOW).sample }
    #grid_size = 10
    #@letters = Array.new(grid_size) { ('A'..'Z').to_a.sample }
    @letters.shuffle!
  end

  def score
    @word = params[:word]
    @letters = params[:letters].split
    @grid_word = inside_grid?(@word, @letters)
    @english_word = english_word?(@word)
    @result = result(@word)
  end

  private

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    return user['found']
  end

  def inside_grid?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter.capitalize) }
  end

  def result(word)
    word.size**2
  end
end
