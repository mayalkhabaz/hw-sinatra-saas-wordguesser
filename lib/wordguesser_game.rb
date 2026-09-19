class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  MAX_WRONG_GUESSES = 7

  # Get a word from remote "random word" service
  attr_reader :word

  def initialize(word)
    @word = word.downcase
    @correct_letters = []
    @incorrect_letters = []
  end

  def guess(letter)
    unless letter.is_a?(String) && letter.length == 1 && letter =~ /[a-zA-Z]/
      raise ArgumentError, "guess must be a single letter"
    end

    letter = letter.downcase
    already_tried = @correct_letters.include?(letter) || @incorrect_letters.include?(letter)
    return false if already_tried

    if @word.include?(letter)
      @correct_letters << letter
    else
      @incorrect_letters << letter
    end
  end

  def guesses
    @correct_letters.join
  end

  def wrong_guesses
    @incorrect_letters.join
  end

  def word_with_guesses
    result = ""
    @word.each_char do |ch|
      result << (@correct_letters.include?(ch) ? ch : "-")
    end
    result
  end

  def check_win_or_lose
    if word_with_guesses == @word
      :win
    elsif @incorrect_letters.length >= MAX_WRONG_GUESSES
      :lose
    else
      :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://randomword.saasbook.info/RandomWord.txt')
    Net::HTTP.get(uri)
  end
end