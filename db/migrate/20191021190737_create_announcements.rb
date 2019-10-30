class CreateAnnouncements < ActiveRecord::Migration[5.2]
  def change
    create_table :announcements do |t|
      t.string :slug
      t.integer :announcement_index
      
      t.references :game
      t.references :player
    end
  end
end
