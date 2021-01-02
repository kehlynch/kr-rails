class TrickSerializer < ActiveModel::Serializer
  attributes :finished

  attribute :index do
    object.trick_index
  end

  attribute :cards do
    object.cards.map do |card|
      ActiveModelSerializers::SerializableResource.new(card, serializer: CardSerializer, key_transform: :camel_lower).as_json[:card]
    end
  end
end
