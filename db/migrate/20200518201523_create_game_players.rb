class CreateGamePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :game_players do |t|
      t.references :game
      t.references :player
      t.integer :position
      t.boolean :forehand, default: false
    end

    change_table :cards do |t|
      t.references :game_player
    end

    change_table :bids do |t|
      t.references :game_player
    end

    change_table :announcements do |t|
      t.references :game_player
    end
  end

  def up
    remove_column :cards, :player_id
    remove_column :bids, :player_id
    remove_column :announcements, :player_id
  end

  def down
    change_table :cards do |t|
      t.references :player
    end

    change_table :bids do |t|
      t.references :player
    end

    change_table :announcements do |t|
      t.references :player
    end
  end
end
