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

ActiveRecord::Schema.define(version: 2018_11_12_004802) do

  create_table "consoles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "friendly_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "msu1_pack_mappings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "track_number", null: false
    t.bigint "msu1_pack_id", null: false
    t.bigint "msu1_pcm_track_id", null: false
    t.bigint "msu1_patch_track_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["msu1_pack_id"], name: "index_msu1_pack_mappings_on_msu1_pack_id"
    t.index ["msu1_patch_track_id"], name: "index_msu1_pack_mappings_on_msu1_patch_track_id"
    t.index ["msu1_pcm_track_id"], name: "index_msu1_pack_mappings_on_msu1_pcm_track_id"
  end

  create_table "msu1_packs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "friendly_name", null: false
    t.bigint "videogame_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["videogame_id"], name: "index_msu1_packs_on_videogame_id"
  end

  create_table "msu1_patch_tracks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "track_number", null: false
    t.string "friendly_name", null: false
    t.bigint "msu1_patch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["msu1_patch_id"], name: "index_msu1_patch_tracks_on_msu1_patch_id"
  end

  create_table "msu1_patches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "friendly_name", null: false
    t.bigint "videogame_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["videogame_id"], name: "index_msu1_patches_on_videogame_id"
  end

  create_table "music_tracks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "type", null: false
    t.string "filename", null: false
    t.bigint "videogame_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["videogame_id"], name: "index_music_tracks_on_videogame_id"
  end

  create_table "videogames", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "friendly_name", null: false
    t.bigint "console_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["console_id"], name: "index_videogames_on_console_id"
  end

end
