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

ActiveRecord::Schema.define(version: 20130924214423) do

  create_table "boards", force: true do |t|
    t.integer  "game_id",    null: false
    t.integer  "player_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "boards", ["game_id"], name: "index_boards_on_game_id"
  add_index "boards", ["player_id"], name: "index_boards_on_player_id"

  create_table "games", force: true do |t|
    t.string   "status",     default: "created"
    t.integer  "width",      default: 10
    t.integer  "height",     default: 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner"
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
    t.integer  "x",                          null: false
    t.integer  "y",                          null: false
    t.integer  "ship_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hit",        default: false
  end

  add_index "positions", ["ship_id"], name: "index_positions_on_ship_id"

  create_table "ships", force: true do |t|
    t.string   "t",          null: false
    t.integer  "board_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ships", ["board_id"], name: "index_ships_on_board_id"

  create_table "shoots", force: true do |t|
    t.integer  "x",          null: false
    t.integer  "y",          null: false
    t.integer  "seq"
    t.integer  "player_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "board_id"
    t.string   "result",     null: false
    t.string   "status"
  end

  add_index "shoots", ["board_id", "x", "y"], name: "index_shoots_on_board_id_and_x_and_y", unique: true
  add_index "shoots", ["board_id"], name: "index_shoots_on_board_id"
  add_index "shoots", ["player_id"], name: "index_shoots_on_player_id"

end
