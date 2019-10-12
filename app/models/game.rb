# frozen_string_literal: true

class Game < ApplicationRecord

  after_create :generate_new_game
  
  has_many :cards, class_name: 'XCard'

  # attr_accessor :talon, :bidding, :tricks, :players

  # after_initialize do |game|
  #   if game.data
  #     @talon = Talon.deserialize(game.data['talon'])
  #     @bidding = Bidding.deserialize(game.data['bidding'])
  #     @tricks = Tricks.deserialize(game.data['tricks'])
  #     @players = game.data['players'].map { |player| Player.deserialize(player) }
  #   else
  #     deck = Deck.new
  #     @talon = deck.talon
  #     @bidding = Bidding.new
  #     @tricks = Tricks.new
  #     @players = Player.players(deck.hands, false)
  #   end
  # end

  private

  def generate_new_game
    Dealer.deal(self)
  end
end
