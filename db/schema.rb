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

ActiveRecord::Schema.define(version: 20130828182618) do

  create_table "boards", force: true do |t|
    t.integer  "game_id",    null: false
    t.integer  "player_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string   "status",     default: "created"
    t.integer  "width",      default: 10
    t.integer  "height",     default: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name",                   null: false
    t.string   "token",                  null: false
    t.integer  "won",        default: 0
    t.integer  "lost",       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", force: true do |t|
    t.integer  "x",          null: false
    t.integer  "y",          null: false
    t.integer  "ship_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ships", force: true do |t|
    t.string   "t",          null: false
    t.integer  "board_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shoots", force: true do |t|
    t.integer  "x",          null: false
    t.integer  "y",          null: false
    t.integer  "seq"
    t.integer  "game_id",    null: false
    t.integer  "player_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
