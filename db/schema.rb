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

ActiveRecord::Schema.define(:version => 20110114040748) do

  create_table "campaigns", :force => true do |t|
    t.integer  "user_id"
    t.integer  "slots_available"
    t.integer  "slot_value"
    t.string   "video_guid"
    t.integer  "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "givey_tip"
    t.integer  "tip_amount"
    t.datetime "payment_completed_at"
    t.text     "friends_hash"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.boolean  "active"
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
  end

  create_table "payment_notifications", :force => true do |t|
    t.text     "params"
    t.string   "status"
    t.string   "transaction_id"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slots", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.boolean  "donated"
    t.integer  "npo_id"
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
    t.string   "profile_pic"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin"
  end

end
