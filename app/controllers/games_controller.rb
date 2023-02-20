require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = ('A'..'Z').to_a.shuffle[1..10]
  end

  def score
    end_time = Time.now
    start_time = Time.parse(params[:start_time])
    @attempt = params[:word].upcase
    grid = params[:letters].split(" ")
    @score_hash = run_game(@attempt, grid, start_time, end_time)
  end


  def input_same_as_grid(attempt, grid)
    attempt_array = attempt.split("")
    attempt_array.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        return false
      end
    end
    return true
  end

  def input_is_a_word(attempt)
    # get the URIs and compare with the attempt string
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized) # < This is a hash {"found"=>true, "word"=>"dog", "length"=>3}
    word["found"]
  end

  def compute_score(attempt, start_time, end_time)
    time = end_time - start_time
    score = (attempt.length * 10) - time.round
    return score
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    return_hash = { score: 0, message: "Default Message", time: 0 }

    if input_is_a_word(attempt) == false || input_same_as_grid(attempt, grid) == false
      return_hash[:message] = "#{attempt} not an english word or not in the grid"
    else
      return_hash[:time] = (end_time - start_time)
      return_hash[:score] = compute_score(attempt, start_time, end_time)
      return_hash[:message] = "#{attempt} gave you #{return_hash[:score]} points, well done!"
    end
    return return_hash
  end

end
