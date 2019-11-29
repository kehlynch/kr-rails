class CreateGameDetailsTables < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name
      t.boolean :human, default: false
      t.integer :points
      t.integer :position

      t.references :game

      t.timestamps
    end

    create_table :cards do |t|
      t.integer :value
      t.string :suit
      t.string :slug
      t.integer :talon_half
      t.integer :played_index
      t.boolean :discard, default: false

      t.references :game
      t.references :player
      t.references :trick

      t.timestamps
    end

    create_table :tricks do |t|
      t.boolean :viewed, default: false
      t.integer :trick_index

      t.references :game
    end

    create_table :bids do |t|
      t.string :slug
      t.integer :bid_index

      t.references :game
      t.references :player
    end

    change_table :games do |t|
      t.string :king
      t.integer :talon_picked
      t.boolean :talon_resolved, default: false
    end
  end
end
