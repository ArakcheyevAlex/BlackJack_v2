# frozen_string_literal: true

class Deck
  ENOUGH_CARDS_FOR_PLAYING = 6

  def initialize
    take_new_deck
  end

  def shuffle!
    cards.shuffle!
  end

  def draw_card
    cards.pop
  end

  def cards_left?
    cards.size
  end

  def cards_enough?
    cards_left? >= ENOUGH_CARDS_FOR_PLAYING
  end

  private

  def take_new_deck
    @cards = []
    Card::SUITS.product(Card::RANKS.keys).map do |(suit, rank)|
      @cards << Card.new(suit, rank)
    end
  end

  attr_reader :cards
end
