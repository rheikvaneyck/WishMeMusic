class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string :name
      t.string :email
      t.string :tel
      t.date :datum
      t.time :zeit
      t.string :strasse
      t.string :stadt
      t.integer :anzahl
      t.integer :anzahl20
      t.integer :anzahl60
      t.boolean :equipment
      t.boolean :beratung
      t.text :kommentar
      t.integer :wish_id
      t.integer :user_id
      
    end
  end

  def down
    drop_table :events
  end
end
