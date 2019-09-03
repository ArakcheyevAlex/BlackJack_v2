# frozen_string_literal: true

class Player
  attr_reader :name, :scores, :money

  FULL_HAND_CARDS_LIMIT = 3

  def initialize(name, start_money:, hidden: true)
    @name = name
    @money = start_money
    @cards = []
    @hidden = hidden
    @scores = 0
  end

  def calculate_scores(new_card)
    @scores += card_price(new_card)
  end

  def card_price(card)
    return 1 if (@scores + card.price > 21) && card.ace?

    card.price
  end

  def take_card(card)
    cards << card
    calculate_scores(card)
  end

  def drop_cards
    self.cards = []
    @scores = 0
  end

  def hidden?
    @hidden
  end

  def open_cards
    @hidden = false
  end

  def hide_cards
    @hidden = true
  end

  def full_hand?
    cards.size >= FULL_HAND_CARDS_LIMIT
  end

  def no_money?
    money.zero?
  end

  def spend_money(value)
    @money -= value
  end

  def make_bet(value)
    spend_money(value)
  end

  def take_money(value)
    @money += value
  end

  alias return_bet take_money
  alias take_prize take_money

  def cards_to_s
    return '***' if hidden?
    return 'no cards' if cards.empty?

    cards_str = ''
    cards.each { |card| cards_str += " #{card}" }
    cards_str
  end

  def scores_to_s
    return '***' if hidden?

    scores.to_s
  end

  private

  attr_accessor :cards
  attr_writer :money
end
