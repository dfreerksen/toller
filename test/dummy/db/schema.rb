# frozen_string_literal: true

ActiveRecord::Schema.define(version: 1) do
  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "priority"
    t.decimal  "rating"
    t.boolean  "visible"
    t.date     "expiration_date"
    t.time     "expiration_time"
    t.datetime "published_at"
    t.json "metadata"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end
end
