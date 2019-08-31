# frozen_string_literal: true
require './user_interface'

class BlackJack
  attr_reader :ui

  def initialize
    @ui = UserInterface.new
  end

  def run
    ui.show_msg('Welcome to BlackJack Game!')
  end
end
