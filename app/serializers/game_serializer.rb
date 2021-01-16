class GameSerializer < ActiveModel::Serializer
  attributes :id, :partner_id, :partner_known, :stage, :valid_announcements, :valid_bids, :king, :won_bid

  attribute :won_bid do
    object.won_bid&.slug
  end

  attribute :next_game_player_id do
    object.next_player&.id
  end

  attribute :bids do
    object.bids.map do |bid|
      ActiveModelSerializers::SerializableResource.new(bid, serializer: BidSerializer, key_transform: :camel_lower).as_json[:bid]
    end
  end

  attribute :announcements do
    object.announcements.map do |announcement|
      ActiveModelSerializers::SerializableResource.new(announcement, serializer: AnnouncementSerializer, key_transform: :camel_lower).as_json[:announcement]
    end
  end

  attribute :game_players do
    object.game_players.map do |p|
      ActiveModelSerializers::SerializableResource.new(p, serializer: GamePlayerSerializer, key_transform: :camel_lower).as_json[:gamePlayer]
    end
  end

  attribute :tricks do
    object.tricks.map do |t|
      ActiveModelSerializers::SerializableResource.new(t, serializer: TrickSerializer, key_transform: :camel_lower).as_json[:trick]
    end
  end

  attribute :king_required do
    object.winning_bid.king?
  end

  attribute :outcomes do
    bid_outcome = {
      slug: object.won_bid&.slug,
      made: !object.won_bid&.off,
      game_players: game_player_game_points,
    }

    [bid_outcome] + object.announcement_scores.map do |a|
      {
      slug: a.slug,
      made: !a.off,
      game_players: object.game_players.map { |p| {id: p.id, points: a.points_for(p) }}
      }
    end
  end

  private

  def game_player_game_points
    won_bid = object.won_bid
    return {} unless won_bid

    return object.game_players.map { |p| {id: p.id, points: p.points }} if won_bid.slug == Bid::TRISCHAKEN
    off = won_bid.off
    points = won_bid.points


    object.declarers.map { |p| { id: p.id, points: off ? -points : points }} +
      object.defenders.map { |p| { id: p.id, points: off ? points : -points }}
  end

end
