class MatchSerializer < ActiveModel::Serializer
  attributes :id
  attribute :hand_description do
    if object.games.count == 0
      'not started'
    else
      "hand #{object.games.count}"
    end
  end

  attribute :players do
    ActiveModel::Serializer::CollectionSerializer.new(object.players, serializer: MatchPlayerSerializer)
  end
end
