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

ActiveRecord::Schema[7.0].define(version: 2025_11_27_100000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "adaptation_types", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adaptations", force: :cascade do |t|
    t.string "title"
    t.integer "year"
    t.bigint "adaptation_type_id", null: false
    t.text "description"
    t.bigint "novel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adaptation_type_id"], name: "index_adaptations_on_adaptation_type_id"
    t.index ["novel_id"], name: "index_adaptations_on_novel_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "ai_search_logs", force: :cascade do |t|
    t.integer "user_id"
    t.text "query"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_ai_search_logs_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "file"
    t.integer "event_id"
    t.float "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
  end

  create_table "audiences", force: :cascade do |t|
    t.string "label"
  end

  create_table "audiences_thematic_collections", id: false, force: :cascade do |t|
    t.bigint "audience_id", null: false
    t.bigint "thematic_collection_id", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "category_type"
  end

  create_table "categories_novels", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "novel_id", null: false
  end

  create_table "categories_people", id: false, force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "category_id", null: false
  end

  create_table "categories_thematic_collections", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "thematic_collection_id", null: false
  end

  create_table "editions", force: :cascade do |t|
    t.bigint "novel_id"
    t.string "title"
    t.bigint "language_id"
    t.bigint "publisher_id"
    t.integer "from_year"
    t.string "isbn"
    t.bigint "pof_poi_id"
    t.string "cover"
    t.text "cover_source"
    t.integer "place_of_publication_id"
    t.string "slug"
    t.index ["language_id"], name: "index_editions_on_language_id"
    t.index ["novel_id"], name: "index_editions_on_novel_id"
    t.index ["pof_poi_id"], name: "index_editions_on_pof_poi_id"
    t.index ["publisher_id"], name: "index_editions_on_publisher_id"
  end

  create_table "editions_organizations", id: false, force: :cascade do |t|
    t.bigint "edition_id", null: false
    t.bigint "organization_id", null: false
  end

  create_table "editions_translators", id: false, force: :cascade do |t|
    t.bigint "edition_id", null: false
    t.bigint "person_id", null: false
    t.index ["edition_id", "person_id"], name: "index_editions_translators_on_edition_id_and_person_id", unique: true
    t.index ["person_id", "edition_id"], name: "index_editions_translators_on_person_id_and_edition_id"
  end

  create_table "event_types", force: :cascade do |t|
    t.string "label"
    t.boolean "hide_from_directory"
  end

  create_table "event_types_events", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "event_type_id", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.date "started"
    t.date "ended"
    t.text "content"
    t.integer "main_event_id"
    t.string "slug"
    t.text "short_summary"
    t.boolean "hide_from_timeline"
  end

  create_table "events_geos", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "geo_id", null: false
  end

  create_table "events_keywords", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "keyword_id", null: false
  end

  create_table "events_materials", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "material_id", null: false
  end

  create_table "events_novels", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "novel_id", null: false
  end

  create_table "events_organizations", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "organization_id"
    t.index ["event_id"], name: "index_events_organizations_on_event_id"
    t.index ["organization_id"], name: "index_events_organizations_on_organization_id"
  end

  create_table "events_people", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "person_id", null: false
  end

  create_table "events_thematic_sections", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "thematic_section_id", null: false
    t.index ["event_id", "thematic_section_id"], name: "idx_events_thematic_sections_on_event_and_section"
    t.index ["thematic_section_id", "event_id"], name: "idx_thematic_sections_events_on_section_and_event"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "galleries", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.string "video"
    t.string "caption"
    t.integer "news_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
  end

  create_table "geos", force: :cascade do |t|
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "polygon"
    t.string "title"
  end

  create_table "geos_materials", id: false, force: :cascade do |t|
    t.bigint "geo_id", null: false
    t.bigint "material_id", null: false
  end

  create_table "geos_novels", force: :cascade do |t|
    t.bigint "geo_id"
    t.bigint "novel_id"
    t.index ["geo_id"], name: "index_geos_novels_on_geo_id"
    t.index ["novel_id"], name: "index_geos_novels_on_novel_id"
  end

  create_table "geos_organizations", id: false, force: :cascade do |t|
    t.bigint "geo_id", null: false
    t.bigint "organization_id", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keywords", force: :cascade do |t|
    t.string "label"
    t.bigint "parent_id"
    t.string "slug"
    t.string "short_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keywords_materials", id: false, force: :cascade do |t|
    t.bigint "keyword_id", null: false
    t.bigint "material_id", null: false
  end

  create_table "keywords_novels", id: false, force: :cascade do |t|
    t.bigint "keyword_id", null: false
    t.bigint "novel_id", null: false
  end

  create_table "keywords_thematic_collections", id: false, force: :cascade do |t|
    t.bigint "keyword_id", null: false
    t.bigint "thematic_collection_id", null: false
  end

  create_table "keywords_thematic_sections", id: false, force: :cascade do |t|
    t.bigint "keyword_id", null: false
    t.bigint "thematic_section_id", null: false
    t.index ["keyword_id", "thematic_section_id"], name: "idx_keywords_thematic_sections_on_keyword_and_section"
    t.index ["thematic_section_id", "keyword_id"], name: "idx_thematic_sections_keywords_on_section_and_keyword"
  end

  create_table "languages", force: :cascade do |t|
    t.string "label"
    t.string "slug"
  end

  create_table "languages_novels", id: false, force: :cascade do |t|
    t.bigint "novel_id", null: false
    t.bigint "language_id", null: false
    t.index ["language_id", "novel_id"], name: "index_languages_novels_on_language_id_and_novel_id"
    t.index ["novel_id", "language_id"], name: "index_languages_novels_on_novel_id_and_language_id"
  end

  create_table "material_authors", force: :cascade do |t|
    t.bigint "material_id"
    t.bigint "person_id"
    t.index ["material_id"], name: "index_material_authors_on_material_id"
    t.index ["person_id"], name: "index_material_authors_on_person_id"
  end

  create_table "material_types", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "material_types_materials", id: false, force: :cascade do |t|
    t.bigint "material_id", null: false
    t.bigint "material_type_id", null: false
  end

  create_table "materials", force: :cascade do |t|
    t.string "title"
    t.text "summary"
    t.text "content"
    t.text "external_document"
    t.boolean "public"
    t.boolean "produced_by_caponeu"
    t.string "material_type"
    t.string "copyright_notice"
    t.json "attachments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.date "published_until"
  end

  create_table "materials_novels", id: false, force: :cascade do |t|
    t.bigint "material_id", null: false
    t.bigint "novel_id", null: false
  end

  create_table "materials_organizations", id: false, force: :cascade do |t|
    t.bigint "material_id", null: false
    t.bigint "organization_id", null: false
  end

  create_table "materials_people", id: false, force: :cascade do |t|
    t.bigint "material_id", null: false
    t.bigint "person_id", null: false
  end

  create_table "materials_thematic_collections", id: false, force: :cascade do |t|
    t.bigint "material_id", null: false
    t.bigint "thematic_collection_id", null: false
  end

  create_table "materials_thematic_sections", id: false, force: :cascade do |t|
    t.bigint "material_id", null: false
    t.bigint "thematic_section_id", null: false
    t.index ["material_id", "thematic_section_id"], name: "idx_materials_thematic_sections_on_material_and_section"
    t.index ["thematic_section_id", "material_id"], name: "idx_thematic_sections_materials_on_section_and_material"
  end

  create_table "news", force: :cascade do |t|
    t.string "title"
    t.text "lead"
    t.string "date"
    t.string "venue"
    t.string "contact"
    t.string "topic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", default: 0
    t.string "slug"
    t.string "gallery_title"
  end

  create_table "novel_authors", force: :cascade do |t|
    t.bigint "novel_id"
    t.bigint "person_id"
    t.index ["novel_id"], name: "index_novel_authors_on_novel_id"
    t.index ["person_id"], name: "index_novel_authors_on_person_id"
  end

  create_table "novel_portrait_authors", force: :cascade do |t|
    t.bigint "novel_id"
    t.bigint "person_id"
    t.index ["novel_id"], name: "index_novel_portrait_authors_on_novel_id"
    t.index ["person_id"], name: "index_novel_portrait_authors_on_person_id"
  end

  create_table "novels", force: :cascade do |t|
    t.string "title"
    t.integer "from_year"
    t.text "portrait_summary"
    t.text "summary"
    t.date "written_at"
    t.bigint "pof_poi_id"
    t.string "english_title"
    t.string "censorship_status"
    t.string "cover"
    t.string "slug"
    t.text "cover_source"
    t.integer "place_of_origin_id"
    t.string "isbn"
    t.integer "publisher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "further_reading"
    t.integer "to_year"
    t.index ["pof_poi_id"], name: "index_novels_on_pof_poi_id"
  end

  create_table "novels_organizations", id: false, force: :cascade do |t|
    t.bigint "novel_id", null: false
    t.bigint "organization_id", null: false
  end

  create_table "novels_people", id: false, force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "novel_id", null: false
  end

  create_table "novels_thematic_collections", id: false, force: :cascade do |t|
    t.bigint "novel_id", null: false
    t.bigint "thematic_collection_id", null: false
  end

  create_table "novels_thematic_sections", id: false, force: :cascade do |t|
    t.bigint "novel_id", null: false
    t.bigint "thematic_section_id", null: false
    t.index ["novel_id", "thematic_section_id"], name: "idx_novels_thematic_sections_on_novel_and_section"
    t.index ["thematic_section_id", "novel_id"], name: "idx_thematic_sections_novels_on_section_and_novel"
  end

  create_table "organization_types", force: :cascade do |t|
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide_from_directory"
  end

  create_table "organization_types_organizations", id: false, force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "organization_type_id", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.text "label"
    t.string "slug"
    t.string "logo"
    t.string "subtitle"
    t.float "sort"
    t.string "added_by"
  end

  create_table "organizations_people", id: false, force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "person_id", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.date "birth"
    t.date "death"
    t.string "place_of_birth"
    t.string "last_name"
    t.string "place_of_death"
    t.string "photo"
    t.text "bio"
    t.string "slug"
    t.text "photo_source"
    t.index ["slug"], name: "index_people_on_slug", unique: true
  end

  create_table "people_person_types", id: false, force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "person_type_id", null: false
  end

  create_table "people_thematic_collections", id: false, force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "thematic_collection_id", null: false
    t.index ["person_id", "thematic_collection_id"], name: "idx_people_thematic_colls_on_person_and_collection"
    t.index ["thematic_collection_id", "person_id"], name: "idx_thematic_colls_people_on_collection_and_person"
  end

  create_table "people_thematic_sections", id: false, force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "thematic_section_id", null: false
    t.index ["person_id", "thematic_section_id"], name: "idx_people_thematic_sections_on_person_and_section"
    t.index ["thematic_section_id", "person_id"], name: "idx_thematic_sections_people_on_section_and_person"
  end

  create_table "person_types", force: :cascade do |t|
    t.string "label"
    t.boolean "hide_from_people_directory"
  end

  create_table "redirects", force: :cascade do |t|
    t.string "old_url"
    t.string "new_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "thematic_collections", force: :cascade do |t|
    t.string "title"
    t.text "summary"
    t.string "cover"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.integer "organization_id"
  end

  create_table "thematic_sections", force: :cascade do |t|
    t.string "title"
    t.text "summary"
    t.string "related_model"
    t.float "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "thematic_collection_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.jsonb "metadata"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "adaptations", "adaptation_types"
  add_foreign_key "adaptations", "novels"
end
