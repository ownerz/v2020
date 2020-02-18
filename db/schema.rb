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

ActiveRecord::Schema.define(version: 2020_02_17_114210) do

  create_table "candidates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "code_id"
    t.string "electoral_district", default: "", comment: "선거구명"
    t.string "party", default: "", comment: "소속정당명"
    t.string "photo", default: "", comment: "사진"
    t.string "name", default: "", comment: "성명"
    t.string "sex", default: "", comment: "성별"
    t.string "birth_date", default: "", comment: "생년월일(연령)"
    t.string "address", default: "", comment: "주소"
    t.string "job", default: "", comment: "직업"
    t.string "education", default: "", comment: "학력"
    t.string "career", default: "", comment: "경력"
    t.string "criminal_record", default: "", comment: "전과기록"
    t.string "reg_date", default: "", comment: "등록일자"
    t.string "wiki_page", default: "", comment: "나무위키 page"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "crawl_id", null: false
    t.index ["code_id"], name: "index_candidates_on_code_id"
    t.index ["crawl_id"], name: "index_candidates_on_crawl_id"
  end

  create_table "codes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "type", null: false
    t.string "name", default: "", comment: "이름"
    t.integer "code", null: false, comment: "코드"
    t.bigint "parent_id"
  end

  create_table "likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "context_type"
    t.bigint "context_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["context_type", "context_id"], name: "index_likes_on_context_type_and_context_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "device_id"
    t.integer "age", default: 0
    t.integer "sex", default: 0
    t.float "latitude", default: 0.0, null: false
    t.float "longitude", default: 0.0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_id"], name: "index_users_on_device_id"
  end

  add_foreign_key "candidates", "codes"
  add_foreign_key "likes", "users"
end
