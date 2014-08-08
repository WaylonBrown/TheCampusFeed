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

ActiveRecord::Schema.define(version: 20140807211741) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "colleges", force: true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "size"
    t.string   "primary_color"
  end

  create_table "comments", force: true do |t|
    t.string   "text"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "post_id"
    t.boolean  "hidden"
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "flags", force: true do |t|
    t.integer  "flaggable_id"
    t.string   "flaggable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partials", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "text"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "college_id"
    t.integer  "lat"
    t.integer  "lon"
    t.boolean  "hidden"
  end

  add_index "posts", ["college_id"], name: "index_posts_on_college_id", using: :btree

  create_table "posts_tags", force: true do |t|
    t.integer "post_id"
    t.integer "tag_id"
  end

  create_table "static_pages", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "text"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["post_id"], name: "index_tags_on_post_id", using: :btree
  add_index "tags", ["text"], name: "index_tags_on_text", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["token"], name: "index_users_on_token", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.boolean  "upvote"
    t.integer  "votable_id"
    t.string   "votable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
