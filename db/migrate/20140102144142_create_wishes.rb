class CreateWishes < ActiveRecord::Migration
  def up
    create_table :wishes do |t|
      t.text :background_musik
      t.text :tanzmusik_genre
      t.text :tanzmusik_zeit
      t.integer :user_id
      
    end
  end

  def down
    drop_table :wishes
  end
end
