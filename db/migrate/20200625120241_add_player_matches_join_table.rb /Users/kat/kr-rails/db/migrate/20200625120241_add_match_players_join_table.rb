class AddMatchPlayersJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :match_players do |t|
      t.timestamps

      t.references :player
      t.references :match
      t.integer :position
    end
  end
end
