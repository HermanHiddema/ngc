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

ActiveRecord::Schema.define(version: 20140917210911) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clubs", force: true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.string   "website"
    t.text     "info"
    t.integer  "contact_person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clubs", ["contact_person_id"], name: "index_clubs_on_contact_person_id", using: :btree

  create_table "games", force: true do |t|
    t.integer  "match_id"
    t.integer  "black_id"
    t.integer  "white_id"
    t.integer  "black_points"
    t.integer  "white_points"
    t.string   "reason"
    t.integer  "board_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["black_id"], name: "index_games_on_black_id", using: :btree
  add_index "games", ["match_id"], name: "index_games_on_match_id", using: :btree
  add_index "games", ["white_id"], name: "index_games_on_white_id", using: :btree

  create_table "leagues", force: true do |t|
    t.string   "name"
    t.integer  "order"
    t.integer  "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "leagues", ["season_id"], name: "index_leagues_on_season_id", using: :btree

  create_table "matches", force: true do |t|
    t.integer  "league_id"
    t.integer  "black_team_id"
    t.integer  "white_team_id"
    t.date     "playing_date"
    t.string   "playing_time"
    t.integer  "venue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["black_team_id"], name: "index_matches_on_black_team_id", using: :btree
  add_index "matches", ["league_id"], name: "index_matches_on_league_id", using: :btree
  add_index "matches", ["venue_id"], name: "index_matches_on_venue_id", using: :btree
  add_index "matches", ["white_team_id"], name: "index_matches_on_white_team_id", using: :btree

  create_table "participants", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "rating"
    t.string   "egd_pin"
    t.integer  "person_id"
    t.integer  "club_id"
    t.integer  "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participants", ["club_id"], name: "index_participants_on_club_id", using: :btree
  add_index "participants", ["person_id"], name: "index_participants_on_person_id", using: :btree
  add_index "participants", ["season_id"], name: "index_participants_on_season_id", using: :btree

  create_table "people", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "egd_pin"
    t.integer  "rating"
    t.integer  "club_id"
    t.string   "email"
    t.string   "email2"
    t.string   "phone"
    t.string   "phone2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["club_id"], name: "index_people_on_club_id", using: :btree

  create_table "seasons", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_members", force: true do |t|
    t.integer  "participant_id"
    t.integer  "team_id"
    t.integer  "board_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_members", ["participant_id"], name: "index_team_members_on_participant_id", using: :btree
  add_index "team_members", ["team_id"], name: "index_team_members_on_team_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.integer  "club_id"
    t.integer  "league_id"
    t.integer  "captain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["captain_id"], name: "index_teams_on_captain_id", using: :btree
  add_index "teams", ["club_id"], name: "index_teams_on_club_id", using: :btree
  add_index "teams", ["league_id"], name: "index_teams_on_league_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "venues", force: true do |t|
    t.integer  "club_id"
    t.string   "name"
    t.integer  "playing_day"
    t.string   "playing_time"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "venues", ["club_id"], name: "index_venues_on_club_id", using: :btree

end
