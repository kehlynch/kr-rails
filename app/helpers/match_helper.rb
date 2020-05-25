module MatchHelper
  def match_date(match)
    match.created_at.strftime('%a %e %b, %H:%M')
  end
end
