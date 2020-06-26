module MatchHelper
  def hand_count_text(match)
    if match.games.count == 0
      'not started'
    else
      "hand #{match.games.count}"
    end
  end

  def match_days_ago_text(match)
    days = match_days_ago(match)
    days == 0 ? 'today' : "#{days} days ago"
  end

  def player_names_text(match)
    match.players.map(&:name).join(', ')
  end

  private

  def round_description
  end

  def match_days_ago(match)
    (Time.zone.now - match.created_at).to_i / 1.day
  end
end
