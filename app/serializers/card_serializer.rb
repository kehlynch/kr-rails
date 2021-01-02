class CardSerializer < ActiveModel::Serializer
  attributes :slug
  attribute :player_position do
    object.game_player.position
  end
end
