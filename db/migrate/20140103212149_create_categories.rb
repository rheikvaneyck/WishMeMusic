class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.string :category
      t.string :value
      t.integer :score
      
    end
  end

  def down
    drop_table :categories
  end
end
