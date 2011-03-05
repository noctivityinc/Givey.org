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

ActiveRecord::Schema.define(:version => 20110305182912) do

  create_table "backgrounds", :force => true do |t|
    t.boolean  "active",             :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "question_id"
  end

  create_table "beta_testers", :force => true do |t|
    t.string   "email"
    t.integer  "access_count"
    t.datetime "last_accessed_at"
    t.text     "feedback"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challengers", :force => true do |t|
    t.string   "uid"
    t.integer  "duel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "challengers", ["uid", "duel_id"], :name => "indx_duel_uid"
  add_index "challengers", ["uid"], :name => "index_challengers_on_uid"

  create_table "donations", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "net",            :precision => 8, :scale => 2
    t.datetime "donated_at"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bill_id"
    t.text     "response"
    t.decimal  "fee",            :precision => 8, :scale => 2
  end

  create_table "fb_errors", :force => true do |t|
    t.string   "code"
    t.string   "message"
    t.integer  "user_id"
    t.text     "user_agent"
    t.string   "source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friends", :force => true do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => true
  end

  add_index "friends", ["uid"], :name => "index_friends_on_uid"
  add_index "friends", ["user_id", "uid"], :name => "ndx_user_id_and_uid"

  create_table "mturks", :force => true do |t|
    t.string   "uid"
    t.string   "confirmation_token"
    t.datetime "completed_at"
    t.datetime "approved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "npos", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.string   "email"
    t.text     "description"
    t.integer  "category_id"
    t.boolean  "feature"
    t.integer  "num_featured"
    t.boolean  "active"
    t.string   "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "attention"
    t.string   "twitter_name"
    t.string   "facebook_url"
    t.string   "guidestar_url"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "paypal_email"
    t.string   "tax_id"
    t.text     "story"
  end

  add_index "npos", ["id", "name"], :name => "index_id_name"
  add_index "npos", ["name"], :name => "index_npos_on_name"

  create_table "profiles", :force => true do |t|
    t.string   "uid"
    t.text     "details"
    t.text     "photos"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "friend_list_count"
    t.integer  "score"
    t.string   "givey_token"
  end

  add_index "profiles", ["friend_list_count", "score"], :name => "index_list_count_score"
  add_index "profiles", ["friend_list_count"], :name => "index_profiles_on_friend_list_count"
  add_index "profiles", ["givey_token"], :name => "index_profiles_on_givey_token"
  add_index "profiles", ["score"], :name => "index_profiles_on_score"
  add_index "profiles", ["uid"], :name => "index_profiles_on_uid"

  create_table "questions", :force => true do |t|
    t.string   "name"
    t.integer  "value"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phrase"
  end

  create_table "sparks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.string   "winner_uid"
    t.string   "friend_uid_1"
    t.string   "friend_uid_2"
    t.string   "friend_uid_3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "email"
    t.string   "name"
    t.string   "gender"
    t.string   "locale"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.text     "location"
    t.string   "givey_token"
    t.integer  "referring_id"
    t.text     "story"
    t.boolean  "post_story_to_wall"
    t.integer  "npo_id"
    t.datetime "completed_round_one_at"
    t.datetime "emailed_invite_friends_at"
    t.datetime "emailed_scores_unlocked_at"
  end

end
