class GameSerializer < ActiveModel::Serializer
  attributes :id, :partner_id, :partner_known, :stage, :valid_bids

  attribute :next_game_player_id do
    object.next_player.id
  end

  attribute :bids do
    object.bids.map do |bid|
      ActiveModelSerializers::SerializableResource.new(bid, serializer: BidSerializer, key_transform: :camel_lower).as_json[:bid]
    end
  end

  attribute :game_players do
    object.game_players.map do |p|
      ActiveModelSerializers::SerializableResource.new(p, serializer: GamePlayerSerializer, key_transform: :camel_lower).as_json[:gamePlayer]
    end
  end

  # has_many :game_players
end
