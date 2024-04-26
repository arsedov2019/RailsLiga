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

ActiveRecord::Schema[7.1].define(version: 2024_04_25_214513) do
  create_table "black_lists", force: :cascade do |t|
    t.string "ticket_num"
    t.integer "document_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "journals", force: :cascade do |t|
    t.string "ticket_num"
    t.string "category"
    t.datetime "date"
    t.string "name"
    t.boolean "status"
    t.boolean "is_enter"
    t.integer "document_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
