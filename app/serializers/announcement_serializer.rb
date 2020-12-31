class AnnouncementSerializer < ActiveModel::Serializer
  attributes :id, :slug

  attribute :player_position do
    object.game_player.position
  end

  # has_many :game_players
end
