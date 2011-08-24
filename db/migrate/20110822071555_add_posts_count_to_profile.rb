class AddPostsCountToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :posts_count, :integer
  end
end
