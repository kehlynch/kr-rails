class RemovePlayersMatchId < ActiveRecord::Migration[5.2]
  def change
    remove_column :players, :match_id
    # remove_index :players, name: :index_players_on_match_id
  end
end
