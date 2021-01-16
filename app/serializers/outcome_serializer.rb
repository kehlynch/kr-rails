class OutcomeSerializer < ActiveModel::Serializer
attrin
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
