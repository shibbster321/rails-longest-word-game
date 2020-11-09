class PagesController < ApplicationController
  def play

    # get random lettrs
    @grid = generate_grid(9)
    # dispaly
    start_time = Time.now
    # ask for response
    # @attempt = params[:answer]
    # does response each 
    end_time = Time.now
    # @difference = end_time - start_time
    return @grid
  end

  def result
    @attempt = params['guess']
    @start_time = params['start_time']
    @grid_test = play
    @end_time = Time.now
    @score = run_game(@attempt, @grid_test, @start_time, @end_time)
    @difference = 1    

  end
  private

    require 'open-uri'
    require 'json'

    def generate_grid(grid_size)
    random = []
    grid_size.times do
        sample = ('a'..'z').to_a.sample(1)
        random << sample[0]
    end
    return random.each { |i| i.upcase! }
    end

    def letter_error_check(attempt, grid)
    error = 0
    attempt.downcase!
    grid.each { |i| i.downcase! }
    attempt.each_char do |letter|
        grid.include?(letter) ? nil : error += 1
        grid.count(letter) >= attempt.count(letter) ? nil : error += 1
    end
    return error.positive?
    end

    def run_game(attempt, grid, start_time, end_time)
    hash = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    score = 0
    if !hash["found"] then message = "not an english word"
    elsif letter_error_check(attempt, grid) then message = "you used letters not in the grid!"
    else
        score = (attempt.length.to_f / grid.length * 10) - ((end_time - start_time) * 0.1)
        message = "well done"
    end
    return { score: score, message: message, time: (end_time - start_time) }
    end

end
