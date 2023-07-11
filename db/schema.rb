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

ActiveRecord::Schema[7.0].define(version: 2023_07_11_123057) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "publications", id: :serial, force: :cascade do |t|
    t.integer "skoob_user_id"
    t.string "title"
    t.string "author"
    t.string "isbn"
    t.string "publisher"
    t.integer "year"
    t.integer "skoob_publication_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "publication_type", default: 0
  end

  create_table "skoob_users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.integer "skoob_user_id"
    t.integer "import_status", default: 0
    t.jsonb "not_imported", default: {}, null: false
    t.integer "publications_count", default: 0
  end

end
