# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140216064523) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "arabic_name"
  end

  create_table "stores", force: true do |t|
    t.string   "phone"
    t.string   "name"
    t.string   "slogan"
    t.string   "status"
    t.string   "location"
    t.string   "city"
    t.string   "country"
    t.string   "category_id"
    t.float    "latitude"
    t.float    "longitude"
    t.json     "hours"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain"
    t.integer  "next"
    t.string   "neighborhood"
    t.integer  "language"
  end

  add_index "stores", ["category_id"], name: "index_stores_on_category_id", using: :btree

  create_table "stores_tags", force: true do |t|
    t.integer  "store_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stores_tags", ["store_id"], name: "index_stores_tags_on_store_id", using: :btree
  add_index "stores_tags", ["tag_id"], name: "index_stores_tags_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
