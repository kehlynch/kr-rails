class CreateGamePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :game_players do |t|
      t.references :game
      t.references :player
      t.boolean :human
      t.string :name
      t.integer :position
      t.boolean :forehand, default: false
      t.string :team
      t.boolean :declarer
      t.boolean :partner
      t.integer :game_points
      t.integer :card_points
      t.boolean :winner
    end

    create_table :announcement_scores do |t|
      t.references :game
      t.string :slug
      t.integer :kontra
      t.boolean :off
      t.boolean :declared
      t.string :team
      t.integer :points
    end

    change_table :cards do |t|
      t.references :game_player
    end

    change_table :bids do |t|
      t.references :game_player
      t.boolean :won
    end

    change_table :announcements do |t|
      t.references :game_player
    end

    change_table :tricks do |t|
      t.references :game_player, optional: :true
      t.boolean :finished, default: false
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
