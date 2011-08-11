class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image
      t.float :longitude
      t.float :latitude
      t.integer :size
      t.references :user
      t.references :post
      t.datetime :taken_at 
      t.timestamps
    end
  end 
end
