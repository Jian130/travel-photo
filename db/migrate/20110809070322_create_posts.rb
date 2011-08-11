class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :message
      t.references :user
      t.datetime :taken_at
      t.timestamps
    end
  end
end
