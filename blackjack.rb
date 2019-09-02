# frozen_string_literal: true

require './user_interface'
require './player'
require './card'
require './deck'

class BlackJack
  START_MONEY = 100

  attr_reader :ui, :player, :dealer, :deck, :bets

  def initialize
    @ui = UserInterface.new
    @bets = 0
  end

  def run
    ui.show_msg('Welcome to BlackJack Game!')
    player_name = ui.choose_player_name
    @player = Player.new(player_name, start_money: START_MONEY, hidden: false)
    @dealer = Player.new('Dealer', start_money: START_MONEY)
    @deck = Deck.new
    shuffle_deck

    loop do
      start_game
      break unless play_again?
    end
  end

  def start_game
    change_deck unless deck.cards_enough?

    deal_cards

    show_state

    calculate_result
  end

  def play_again?
    ui.show_msg "Play again? 'y' or 'n':"
    answer = gets.chomp
    answer == 'y'
  end

  def show_state
    ui.show_player_state(player)
    ui.show_player_state(dealer)
    ui.show_balance(player, dealer)
  end

  # rubocop:disable Metrics/AbcSize
  def calculate_result
    dealer.open_cards

    show_state

    if player.scores > 21
      dealer_win
    elsif dealer.scores > 21
      player_win
    elsif player.scores > dealer.scores
      player_win
    elsif player.scores == dealer.scores
      tie
    else
      dealer_win
    end
  end
  # rubocop:enable Metrics/AbcSize

  def player_win
    ui.win_msg(player)
  end

  def dealer_win
    ui.win_msg(dealer)
  end

  def tie
    ui.tie_msg
  end

  def deal_cards
    drop_cards

    2.times do
      player.take_card(deck.draw_card)
      dealer.take_card(deck.draw_card)
    end
  end

  def drop_cards
    player.drop_cards
    dealer.drop_cards
  end

  def shuffle_deck
    deck.shuffle!
    ui.deck_shuffle_msg
  end

  def change_deck
    deck.take_new_deck
    shuffle_deck
  end
end
