class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :vicinity
      t.string :phone
      t.string :address
      t.string :link
      t.string :attribution 
      t.string :reference
      t.float :longitude
      t.float :latitude
      t.integer :posts_count
      
      t.integer :parent_id
      t.string :google_id
      t.datetime :refreshed_at
      t.timestamps
    end
  end
end
