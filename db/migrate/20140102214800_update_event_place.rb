class UpdateEventPlace < ActiveRecord::Migration
  def up
    add_column :events, :ort, :string
  end

  def down
    remove_column :events, :ort
  end
end