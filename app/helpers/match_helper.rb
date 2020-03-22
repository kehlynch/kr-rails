module MatchHelper
  def match_date(match)
    match.created_at.strftime('%a %e %b, %H:%M')
  end

  # TODO what's all of this doing here - it's abut games
  def bid_shorthand(game)
    winning_bid = game.bids.highest
    BidPresenter.new(winning_bid.slug).shorthand
  end

  def points_classes(data)
    hash_to_strings(data, [:forehand, :declarer, :winner]).join(' ')
  end

  def announcement_classes(data)
    class_list = hash_to_strings(data, [:off, :defence, :declared])
    add_kontra_class(class_list, data[:kontra])
  end

  def bid_classes(data)
    class_list = hash_to_strings(data, [:off, :vs_three])
    add_kontra_class(class_list, data[:kontra])
  end

  def add_kontra_class(class_list, kontra)
    class_list << kontra_class(kontra) if kontra_class(kontra)
    class_list.join(' ')
  end

  def kontra_class(kontra)
    { 2 => 'kontra', 4 => 'rekontra', 8 => 'subkontra' }[kontra]
  end

  private

  def hash_to_strings(lookup, keys)
    lookup
      .slice(*keys)
      .select { |k, v| v }
      .compact
      .keys
      .map(&:to_s)
  end
end
