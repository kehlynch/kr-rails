class CreateGameDetailsTables < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :name
      t.boolean :human
      t.integer :points

      t.timestamps
    end

    create_table :cards do |t|
      t.string :slug
      t.integer :talon_half
      t.integer :trick
      t.boolean :discard

      t.references :game
      t.references :player

      t.timestamps
    end

    create_table :bids do |t|
      t.string :slug

      t.references :game
      t.references :player

      t.timestamps
    end
  end
end
