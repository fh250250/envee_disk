# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_23_051917) do

  create_table "blobs", force: :cascade do |t|
    t.string "sha256", limit: 64, null: false
    t.string "mime"
    t.bigint "size", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sha256"], name: "index_blobs_on_sha256", unique: true
  end

  create_table "folders", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.integer "parent_id"
    t.integer "lft", null: false
    t.integer "rgt", null: false
    t.integer "depth", default: 0, null: false
    t.integer "children_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["depth"], name: "index_folders_on_depth"
    t.index ["lft"], name: "index_folders_on_lft"
    t.index ["parent_id", "name"], name: "index_folders_on_parent_id_and_name", unique: true
    t.index ["parent_id"], name: "index_folders_on_parent_id"
    t.index ["rgt"], name: "index_folders_on_rgt"
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "meta_files", force: :cascade do |t|
    t.string "name", null: false
    t.integer "folder_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_meta_files_on_blob_id"
    t.index ["folder_id", "name"], name: "index_meta_files_on_folder_id_and_name", unique: true
    t.index ["folder_id"], name: "index_meta_files_on_folder_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.string "name", null: false
    t.string "sha256", limit: 64, null: false
    t.bigint "size", null: false
    t.integer "part_size", null: false
    t.integer "cursor", default: 0, null: false
    t.integer "folder_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["folder_id", "sha256"], name: "index_uploads_on_folder_id_and_sha256", unique: true
    t.index ["folder_id"], name: "index_uploads_on_folder_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "folders", "folders", column: "parent_id"
  add_foreign_key "folders", "users"
  add_foreign_key "meta_files", "blobs"
  add_foreign_key "meta_files", "folders"
  add_foreign_key "uploads", "folders"
end
