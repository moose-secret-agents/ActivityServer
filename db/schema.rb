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

ActiveRecord::Schema.define(version: 20151021134342) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_points", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.decimal  "lat"
    t.string   "activity"
    t.integer  "training_session_id"
    t.decimal  "long"
    t.decimal  "elevation"
    t.integer  "activity_certainty"
  end

  add_index "data_points", ["training_session_id"], name: "index_data_points_on_training_session_id", using: :btree

  create_table "training_sessions", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.decimal  "elevation_gain"
    t.decimal  "distance"
    t.integer  "duration"
    t.string   "activity"
    t.decimal  "avg_speed"
    t.decimal  "current_speed"
    t.integer  "training_points"
  end

  add_index "training_sessions", ["user_id"], name: "index_training_sessions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "training_sessions", "users"
end
