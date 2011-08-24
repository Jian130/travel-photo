# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110822071555) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "likes", :force => true do |t|
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "vicinity"
    t.string   "phone"
    t.string   "address"
    t.string   "link"
    t.string   "attribution"
    t.string   "reference"
    t.float    "longitude"
    t.float    "latitude"
    t.integer  "posts_count"
    t.integer  "parent_id"
    t.string   "google_id"
    t.datetime "refreshed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "image"
    t.float    "longitude"
    t.float    "latitude"
    t.integer  "size"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "taken_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "message"
    t.integer  "user_id"
    t.datetime "taken_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.integer  "place_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "hometown"
    t.string   "timezone"
    t.string   "locale"
    t.string   "bio"
    t.integer  "private"
    t.integer  "score"
    t.integer  "rank"
    t.boolean  "disable"
    t.integer  "countries_count"
    t.integer  "cities_count"
    t.integer  "photos_count"
    t.integer  "followers_count"
    t.integer  "followings_count"
    t.integer  "activities_count"
    t.integer  "notifications_count"
    t.string   "web"
    t.string   "facebook"
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "posts_count"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
