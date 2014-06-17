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

ActiveRecord::Schema.define(version: 20140617072208) do

  create_table "questions", force: true do |t|
    t.string   "title",                       null: false
    t.string   "description"
    t.text     "options",                     null: false
    t.integer  "teacher_id"
    t.string   "answer",                      null: false
    t.boolean  "multiple",    default: false
    t.integer  "difficulty",  default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["title", "teacher_id", "difficulty"], name: "index_questions_on_title_and_teacher_id_and_difficulty", using: :btree

  create_table "students", force: true do |t|
    t.string   "stuid",           limit: 50
    t.string   "name",                       null: false
    t.string   "hashed_password"
    t.boolean  "sex"
    t.string   "profession"
    t.integer  "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", force: true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.boolean  "is_admin",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end