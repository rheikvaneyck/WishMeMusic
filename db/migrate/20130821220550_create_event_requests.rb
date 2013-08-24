class CreateEventRequests < ActiveRecord::Migration
  def up
    create_table :event_requests do |t|
      t.string :Name
      t.string :Email
      t.string :Tel
      t.date :EventDate
      t.time :Start
      t.string :Strasse
      t.string :Ort
      t.integer :AnzahlG
      t.integer :AnzahlG20
      t.integer :AnzahlG60
      t.boolean :EquipExist
      t.boolean :TechConsult
      t.text :Kommentar
      
    end
  end

  def down
    drop_table :event_requests
  end
end
