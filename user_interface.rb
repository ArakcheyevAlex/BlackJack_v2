# frozen_string_literal: true

class UserInterface
  def show_msg(msg)
    puts msg
  end

  def show_player_state(player)
    puts "#{player.name}'s:"
    puts " cards: #{player.cards_to_s}"
    puts " scores: #{player.scores_to_s}"
  end

  def show_balance(player, dealer)
    puts "Balance ==> #{player.name}: #{player.money}, Dealer: #{dealer.money}"
    puts ''
  end

  def show_bets(bets)
    puts "Bets ==> #{bets}"
    puts ''
  end

  def win_msg(player)
    puts ">> #{player.name} wins!!!"
  end

  def tie_msg
    puts '>> Tie!'
  end

  def deck_shuffle_msg
    puts '>> Deck shuffled'
  end

  def choose_player_name
    loop do
      puts 'Enter your name:'
      name = gets.chomp
      return name if name
    end
  end

  def play_again?
    show_msg "Play again? 'y' or 'n':"
    answer = gets.chomp
    answer == 'y'
  end

  def turn_menu(full_hand)
    puts '1. Stand'
    puts '2. Open cards'
    puts '3. Hit' unless full_hand
    puts 'Enter your choice:'
    choice = gets.chomp.to_i
    case choice
    when 1 then return :stand
    when 2 then return :open
    when 3 then return :hit
    else return nil
    end
  end
end
