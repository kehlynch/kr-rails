class AddViewedFlagsToGamePlayers < ActiveRecord::Migration[5.2]
  def change
    change_table :game_players do |t|
      t.boolean :viewed_bids, default: false
      t.boolean :viewed_kings, default: false
      t.boolean :viewed_talon, default: false
      t.boolean :viewed_announcements, default: false
      t.integer :viewed_trick_index, default: nil
    end
  end
end
