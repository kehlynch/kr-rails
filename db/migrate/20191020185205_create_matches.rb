class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.timestamps
    end

    change_table :games do |t|
      t.references :match
    end

    change_table :players do |t|
      t.references :match
    end

    remove_reference(:players, :game)
  end
end
