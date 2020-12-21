class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :points, :game_count, :name

  attribute :matches do
    ActiveModel::Serializer::CollectionSerializer.new(object.matches, serializer: MatchSerializer)
  end
end

