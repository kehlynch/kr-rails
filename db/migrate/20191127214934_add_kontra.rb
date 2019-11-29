class AddKontra < ActiveRecord::Migration[5.2]
  def change
    change_table :bids do |t|
      t.integer :kontra
    end

    change_table :announcements do |t|
      t.integer :kontra
    end
  end
end
