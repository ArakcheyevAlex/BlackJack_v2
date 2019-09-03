# frozen_string_literal: true

require './user_interface'
require './player'
require './card'
require './deck'

class BlackJack
  START_MONEY = 100
  BET = 10
  DEALER_SCORES_LIMIT = 17

  attr_reader :ui, :player, :dealer, :deck

  def initialize
    @ui = UserInterface.new
    @bets = 0
  end

  def run
    first_setup_game

    loop do
      break if no_money_left?

      start_game

      break unless ui.play_again?
    end
  end

  def first_setup_game
    ui.show_msg('Welcome to BlackJack Game!')
    player_name = ui.choose_player_name
    @player = Player.new(player_name, start_money: START_MONEY, hidden: false)
    @dealer = Player.new('Dealer', start_money: START_MONEY)
    @deck = Deck.new
    shuffle_deck
  end

  def start_game
    setup_game

    loop do
      break if player_turn == :open

      break if game_finished?

      show_state

      dealer_turn
      show_state
      break if game_finished?
    end
    calculate_result
  end

  def setup_game
    change_deck unless deck.cards_enough?

    dealer.hide_cards
    make_bets
    show_balance
    deal_cards
    show_state
  end

  def game_finished?
    return true if player.full_hand? && dealer.full_hand?

    false
  end

  def player_turn
    player_action = ui.turn_menu(player.full_hand?) until player_action
    player.take_card(deck.draw_card) if player_action == :hit
    player_action
  end

  def dealer_turn
    return if dealer.scores >= DEALER_SCORES_LIMIT

    dealer.take_card(deck.draw_card)
  end

  def show_state
    ui.show_player_state(player)
    ui.show_player_state(dealer)
  end

  def show_balance
    ui.show_balance(player, dealer)
    ui.show_bets(bets)
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
    show_balance
  end
  # rubocop:enable Metrics/AbcSize

  def player_win
    ui.win_msg(player)
    pay_to_player(player)
  end

  def dealer_win
    ui.win_msg(dealer)
    pay_to_player(dealer)
  end

  def tie
    ui.tie_msg
    money_back
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

  def make_bets
    dealer.make_bet(BET)
    player.make_bet(BET)
    self.bets = BET * 2
  end

  def pay_to_player(target)
    target.take_prize(bets)
    self.bets = 0
  end

  def money_back
    dealer.return_bet(bets / 2)
    player.return_bet(bets / 2)
    self.bets = 0
  end

  def no_money_left?
    if player.no_money?
      ui.show_msg("#{player.name}: out of money")
      return true
    end
    if dealer.no_money?
      ui.show_msg('Dealer: out of money')
      return true
    end
    false
  end

  private

  attr_accessor :bets
end
