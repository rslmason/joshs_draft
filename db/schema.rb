# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_02_05_223845) do

  create_table "drafts", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "result_id"
    t.integer "total_players", limit: 8
    t.integer "draw"
    t.integer "num_selections"
    t.boolean "drawn", default: false
  end

  create_table "results", force: :cascade do |t|
    t.integer "draft_id"
    t.integer "selection_id"
  end

  create_table "selections", force: :cascade do |t|
    t.integer "user_id"
    t.integer "draft_id"
    t.integer "faction"
  end

  create_table "user_drafts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "draft_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.string "token"
    t.boolean "admin", default: false
  end

end
