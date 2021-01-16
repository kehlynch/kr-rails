class AnnouncementScore < ApplicationRecord
  belongs_to :game

  def announcers
    game_players.select { |gp| gp.team == team }
  end

  def points_for(game_player)
    if game_player.team == team
      off ? -points : points
    else
      off ? points : -points
    end
  end
end
