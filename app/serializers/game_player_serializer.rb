class GamePlayerSerializer < ActiveModel::Serializer
  attributes :id, :player_id, :name, :forehand, :declarer, :position, :viewed_bids, :viewed_kings, :viewed_talon, :viewed_announcements, :viewed_trick_index

  attribute :cards do
    ActiveModel::Serializer::CollectionSerializer.new(object.hand_cards, each_serializer: CardSerializer)
  end

  # has_many :game_players
  # def initialize(game_player, game)
  #   @game_player = game_player
  #   @game = game
  # end

  # def serializable_hash
  #   {
  #     id: @game_player.player_id,
  #     name: @game_player.player.name,
  #     forehand: @game_player.forehand?,
  #     declarer: @game_player.declarer?,
  #     partner: known_partner?,
  #     cards: @game_player.hand_cards.map { |c| CardSerializer.new(c).serializable_hash },
  #     next_to_play: @game.next_player.id == @game_player.id,
  #     announcements: 'announcements',
  #     game_playerA.next_player.id == @game_player.id
  #   }
  # end

  # private

  # def known_partner?
  #   king_played = @game.cards.find do |c|
  #     c.trick_id.present? && c.slug == @game.king
  #   end.present?

  #   @game.partner&.id == @game_player&.player_id && (king_played || @active)
  # end
end
