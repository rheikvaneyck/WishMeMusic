class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :firstname
      t.string :name
      t.string :aka_dj_name
      t.string :password_hash
      t.string :email
      t.string :tel
      t.string :role
      
    end
  end

  def down
    drop_table :users
  end
end
