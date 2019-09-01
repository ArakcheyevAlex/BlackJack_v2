# frozen_string_literal: true

class Card
  SUITS = ['♠', '♥', '♣', '♦'].freeze
  RANKS = {
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'J' => 10,
    'Q' => 10,
    'K' => 10,
    'A' => 11
  }.freeze

  attr_reader :price, :view

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
    @price = RANKS[rank]
    @view = "#{rank}#{suit}"
  end

  def ace?
    @rank == 'A'
  end

  def to_s
    @view
  end
end
