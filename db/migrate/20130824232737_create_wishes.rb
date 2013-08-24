class CreateWishes < ActiveRecord::Migration
  def up
    create_table :wishes do |t|
      t.integer :event_id
      t.text :wishlist
      
    end
  end

  def down
    drop_table :wishes
  end
end
