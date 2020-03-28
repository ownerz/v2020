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

ActiveRecord::Schema.define(version: 2020_03_27_004026) do

  create_table "boards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.integer "board_type"
    t.string "title", null: false
    t.text "body"
    t.string "link", limit: 1000
    t.integer "seq"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "image", limit: 1000
  end

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
    t.string "candidate_no", default: "", null: false
    t.string "number", default: ""
    t.string "property", default: ""
    t.string "military", default: ""
    t.string "candidate_number", default: ""
    t.string "tax_payment", default: ""
    t.string "latest_arrears", default: ""
    t.string "arrears", default: ""
    t.index ["code_id"], name: "index_candidates_on_code_id"
  end

  create_table "codes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "type", null: false
    t.string "name1", default: "", comment: "이름"
    t.string "name2", default: "", comment: "이름"
    t.integer "code", null: false, comment: "코드"
    t.bigint "parent_id"
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.bigint "user_id"
    t.text "body"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "congressmen", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "code_id"
    t.string "electoral_district", default: "", comment: "선거구명"
    t.string "party", default: "", comment: "소속정당명"
    t.string "name", default: "", comment: "성명"
    t.string "sex", default: "", comment: "성별"
    t.string "birth_date", default: "", comment: "생년월일(연령)"
    t.string "address", default: "", comment: "주소"
    t.string "job", default: "", comment: "직업"
    t.string "education", default: "", comment: "학력"
    t.string "career", default: "", comment: "경력"
    t.string "voting_rate", default: "", comment: "득표수(득표율)"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code_id"], name: "index_congressmen_on_code_id"
  end

  create_table "district_details", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "code_id"
    t.integer "district_count", null: false, comment: "읍면동수"
    t.integer "voting_district_count", null: false, comment: "투표구수"
    t.integer "population", null: false, comment: "인구수"
    t.integer "election_population", null: false, comment: "선거인수"
    t.integer "absentee", null: false, comment: "거소투표(부재자) 신고인명부 등재자수"
    t.decimal "voting_rate", precision: 5, scale: 2, null: false, comment: "인구대비 선거인 비율(%)"
    t.integer "households", null: false, comment: "새대수"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code_id"], name: "index_district_details_on_code_id"
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

  create_table "photos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "context_type"
    t.bigint "context_id"
    t.integer "photo_type", null: false
    t.string "url", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["context_type", "context_id"], name: "index_photos_on_context_type_and_context_id"
  end

  create_table "temp_candidates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "electoral_district", default: "", comment: "선거구명"
    t.string "party", default: "", comment: "소속정당명"
    t.string "name", default: "", comment: "성명"
  end

  create_table "user_audits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "device_id", null: false
    t.string "request_url", null: false
    t.text "geo_info"
    t.string "remote_ip", limit: 24, default: ""
    t.string "platform", limit: 32, default: ""
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country", default: ""
    t.string "region", default: ""
    t.string "city", default: ""
    t.string "postal", default: ""
    t.string "loc", default: ""
    t.index ["device_id"], name: "index_user_audits_on_device_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci", force: :cascade do |t|
    t.string "device_id", null: false
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
  add_foreign_key "comments", "users"
  add_foreign_key "congressmen", "codes"
  add_foreign_key "district_details", "codes"
  add_foreign_key "likes", "users"
end
