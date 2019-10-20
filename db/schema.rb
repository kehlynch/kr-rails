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

ActiveRecord::Schema.define(version: 2019_10_12_151807) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bids", force: :cascade do |t|
    t.string "slug"
    t.integer "bid_index"
    t.bigint "game_id"
    t.bigint "player_id"
    t.index ["game_id"], name: "index_bids_on_game_id"
    t.index ["player_id"], name: "index_bids_on_player_id"
  end

  create_table "cards", force: :cascade do |t|
    t.integer "value"
    t.string "suit"
    t.string "slug"
    t.integer "talon_half"
    t.integer "played_index"
    t.boolean "discard", default: false
    t.bigint "game_id"
    t.bigint "player_id"
    t.bigint "trick_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_cards_on_game_id"
    t.index ["player_id"], name: "index_cards_on_player_id"
    t.index ["trick_id"], name: "index_cards_on_trick_id"
  end

  create_table "games", force: :cascade do |t|
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "king"
    t.integer "talon_picked"
    t.boolean "talon_resolved", default: false
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.boolean "human", default: false
    t.integer "points"
    t.integer "position"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_players_on_game_id"
  end

  create_table "tricks", force: :cascade do |t|
    t.boolean "viewed", default: false
    t.integer "trick_index"
    t.bigint "game_id"
    t.index ["game_id"], name: "index_tricks_on_game_id"
  end

end
