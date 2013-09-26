class CreateWishes < ActiveRecord::Migration
  def up
    create_table :wishes do |t|
      t.string :background_musik
      t.string :tanzmusik_genre
      t.string :tanzmusik_zeit
      t.integer :user_id
      
    end
  end

  def down
    drop_table :wishes
  end
end
