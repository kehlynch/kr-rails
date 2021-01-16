class AddAnnouncementPointsToGamePlayers < ActiveRecord::Migration[5.2]
  def change
    change_table :game_players do |t|
      t.integer :announcement_points, default: nil
    end
  end
end
