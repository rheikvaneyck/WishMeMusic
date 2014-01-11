class CreateMusics < ActiveRecord::Migration
  def up
    create_table :musics do |t|
      t.string :category
      t.string :name
      t.text :description
      
    end
  end

  def down
    drop_table :musics
  end
end
