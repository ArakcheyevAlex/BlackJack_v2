# frozen_string_literal: true

class Player
  attr_reader :name, :scores
  attr_accessor :money

  FULL_HAND_CARDS_LIMIT = 3

  def initialize(name, money, hidden = true)
    @name = name
    @money = money
    @cards = []
    @hidden = hidden
    @scores = 0
  end

  def take_card(card)
    card_value = card.price
    card_value = 1 if (@scores + card_value > 21) && card.ace?
    @scores += card_value
    cards << card
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
end
