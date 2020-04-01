class Game
    def initalize
        @alphabet = "abcdefghijklmnopqrstuvwxyz"
    end

    def play
        question
        if @result != "1" && @result != "2"
            return play
        end
        if @result == "1"
            return new_game
        else
            return load_game
        end
    end

    private

    def question
        puts "Type 1 for a new game or type 2 to load a game."
        @result = gets.chomp
    end

    def new_game
        @game_over = false
        @wrong = 0
        @wrong_char = []
        @guessed_letters = []
        random_word
        generate_dash
        while @wrong < 6 && !@game_over
            puts "You have #{6-@wrong} guess(es) left"
            puts @answer.join(" ")
            puts "Wrong characters below"
            puts @wrong_char.join(" ")
            guess
            answer_check
        end
        puts @random
    end

    def random_word
        File.open("5desk.txt") do |file|
            @file_words = file.readlines().select {|line| line.strip.length >= 5 && line.strip.length <= 12}
            @random = @file_words[Random.rand(0...@file_words.size())].strip.downcase
        end
    end

    def generate_dash
        @answer = []
        @random.length.times do
            @answer.push("_")
        end
    end

    def guess
        puts "Choose your letter"
        @guess = gets.chomp.downcase
        if @guessed_letters.include? @guess || @guess.length != 1 || !(@alphabet.include? @guess)
            puts "Please choose one letter that you haven't guessed before"
            return guess
        end
    end

    def answer_check
        counter = 0
        @random.each_char.with_index do |letter, index|
            if letter === @guess
                counter += 1
                @answer[index] = @guess
            end
        end
        if counter == 0
            puts "The letter is not in the word"
            @wrong += 1
            @wrong_char.push(@guess)
            @guessed_letters.push(@guess)
        elsif !@answer.include? "_"
            puts "You won the game!"
            @game_over = true
        else
            puts "You guessed right!"
            @guessed_letters.push(@guess)
        end
        if @wrong == 6
            puts "You lost the game"
        end
    end


end
Game.new.play