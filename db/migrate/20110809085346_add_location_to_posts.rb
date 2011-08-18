class AddLocationToPosts < ActiveRecord::Migration
  def up
    change_table :posts do |t|
      t.references :location
    end
  end
  
  def down
    remove_column :posts, :location_id
  end
end
