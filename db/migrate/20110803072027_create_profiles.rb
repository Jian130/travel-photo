class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :username
      t.integer :place_id
      t.string :first_name
      t.string :last_name
      t.string :hometown
      t.string :timezone
      t.string :locale
      t.string :bio
      t.integer :private
      t.integer :score
      t.integer :rank
      t.boolean :disable
      t.integer :countries_count
      t.integer :cities_count
      t.integer :photos_count
      t.integer :followers_count
      t.integer :followings_count
      t.integer :activities_count
      t.integer :notifications_count
      t.string :web
      t.string :facebook
      t.string :twitter

      t.timestamps
    end
  end
end
