module MatchHelper
  def match_date(match)
    match.created_at.strftime('%a %e %b, %H:%M')
  end

  def points_classes(data)
    hash_to_strings(data, [:forehand, :declarer, :winner]).join(' ')
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
