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

ActiveRecord::Schema.define(version: 20170608194015) do

  create_table "credentials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "title", null: false, comment: "Unique name of the credential"
    t.string "url", comment: "URL to have a direct link to access the web page"
    t.string "login", comment: "User or email used to login to the web page"
    t.text "comment", comment: " Additional information like password hints etc."
    t.string "token", null: false, comment: "Identifier for the Safe"
    t.boolean "secured", default: false, null: false, comment: "If set the stored data is protected by an additional password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "index_credentials_on_title", unique: true
    t.index ["token"], name: "index_credentials_on_token", unique: true
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "email", default: "", null: false, comment: "Can be used as unique identifier of the user"
    t.string "name", default: "", null: false, comment: "Can be used as unique identifier of the user"
    t.string "encrypted_password", default: "", null: false, comment: "Password for the user"
    t.integer "sign_in_count", default: 0, null: false, comment: "How often does the user visit the side"
    t.datetime "current_sign_in_at", comment: "Latest login timestamp"
    t.datetime "last_sign_in_at", comment: "Last visit timestamp"
    t.string "current_sign_in_ip", comment: "Latest login address"
    t.string "last_sign_in_ip", comment: "Last visit address"
    t.integer "failed_attempts", default: 0, null: false, comment: "Count failed login attempts"
    t.datetime "locked_at", comment: "Used to look the user for some time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
