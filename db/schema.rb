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

ActiveRecord::Schema.define(version: 20151124022303) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", id: :uuid, force: :cascade do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.text     "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["time"], name: "index_ahoy_events_on_time", using: :btree
  add_index "ahoy_events", ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree

  create_table "blogposts", force: :cascade do |t|
    t.string   "title"
    t.string   "short_description"
    t.text     "body"
    t.string   "status"
    t.integer  "author_id"
    t.datetime "published_at"
    t.string   "featured_image_file_name"
    t.string   "featured_image_content_type"
    t.integer  "featured_image_file_size"
    t.datetime "featured_image_updated_at"
  end

  create_table "comfy_cms_blocks", force: :cascade do |t|
    t.string   "identifier",     null: false
    t.text     "content"
    t.integer  "blockable_id"
    t.string   "blockable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_blocks", ["blockable_id", "blockable_type"], name: "index_comfy_cms_blocks_on_blockable_id_and_blockable_type", using: :btree
  add_index "comfy_cms_blocks", ["identifier"], name: "index_comfy_cms_blocks_on_identifier", using: :btree

  create_table "comfy_cms_categories", force: :cascade do |t|
    t.integer "site_id",          null: false
    t.string  "label",            null: false
    t.string  "categorized_type", null: false
  end

  add_index "comfy_cms_categories", ["site_id", "categorized_type", "label"], name: "index_cms_categories_on_site_id_and_cat_type_and_label", unique: true, using: :btree

  create_table "comfy_cms_categorizations", force: :cascade do |t|
    t.integer "category_id",      null: false
    t.string  "categorized_type", null: false
    t.integer "categorized_id",   null: false
  end

  add_index "comfy_cms_categorizations", ["category_id", "categorized_type", "categorized_id"], name: "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", unique: true, using: :btree

  create_table "comfy_cms_files", force: :cascade do |t|
    t.integer  "site_id",                                    null: false
    t.integer  "block_id"
    t.string   "label",                                      null: false
    t.string   "file_file_name",                             null: false
    t.string   "file_content_type",                          null: false
    t.integer  "file_file_size",                             null: false
    t.string   "description",       limit: 2048
    t.integer  "position",                       default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_files", ["site_id", "block_id"], name: "index_comfy_cms_files_on_site_id_and_block_id", using: :btree
  add_index "comfy_cms_files", ["site_id", "file_file_name"], name: "index_comfy_cms_files_on_site_id_and_file_file_name", using: :btree
  add_index "comfy_cms_files", ["site_id", "label"], name: "index_comfy_cms_files_on_site_id_and_label", using: :btree
  add_index "comfy_cms_files", ["site_id", "position"], name: "index_comfy_cms_files_on_site_id_and_position", using: :btree

  create_table "comfy_cms_layouts", force: :cascade do |t|
    t.integer  "site_id",                    null: false
    t.integer  "parent_id"
    t.string   "app_layout"
    t.string   "label",                      null: false
    t.string   "identifier",                 null: false
    t.text     "content"
    t.text     "css"
    t.text     "js"
    t.integer  "position",   default: 0,     null: false
    t.boolean  "is_shared",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_layouts", ["parent_id", "position"], name: "index_comfy_cms_layouts_on_parent_id_and_position", using: :btree
  add_index "comfy_cms_layouts", ["site_id", "identifier"], name: "index_comfy_cms_layouts_on_site_id_and_identifier", unique: true, using: :btree

  create_table "comfy_cms_pages", force: :cascade do |t|
    t.integer  "site_id",                        null: false
    t.integer  "layout_id"
    t.integer  "parent_id"
    t.integer  "target_page_id"
    t.string   "label",                          null: false
    t.string   "slug"
    t.string   "full_path",                      null: false
    t.text     "content_cache"
    t.integer  "position",       default: 0,     null: false
    t.integer  "children_count", default: 0,     null: false
    t.boolean  "is_published",   default: true,  null: false
    t.boolean  "is_shared",      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_pages", ["parent_id", "position"], name: "index_comfy_cms_pages_on_parent_id_and_position", using: :btree
  add_index "comfy_cms_pages", ["site_id", "full_path"], name: "index_comfy_cms_pages_on_site_id_and_full_path", using: :btree

  create_table "comfy_cms_revisions", force: :cascade do |t|
    t.string   "record_type", null: false
    t.integer  "record_id",   null: false
    t.text     "data"
    t.datetime "created_at"
  end

  add_index "comfy_cms_revisions", ["record_type", "record_id", "created_at"], name: "index_cms_revisions_on_rtype_and_rid_and_created_at", using: :btree

  create_table "comfy_cms_sites", force: :cascade do |t|
    t.string  "label",                       null: false
    t.string  "identifier",                  null: false
    t.string  "hostname",                    null: false
    t.string  "path"
    t.string  "locale",      default: "en",  null: false
    t.boolean "is_mirrored", default: false, null: false
  end

  add_index "comfy_cms_sites", ["hostname"], name: "index_comfy_cms_sites_on_hostname", using: :btree
  add_index "comfy_cms_sites", ["is_mirrored"], name: "index_comfy_cms_sites_on_is_mirrored", using: :btree

  create_table "comfy_cms_snippets", force: :cascade do |t|
    t.integer  "site_id",                    null: false
    t.string   "label",                      null: false
    t.string   "identifier",                 null: false
    t.text     "content"
    t.integer  "position",   default: 0,     null: false
    t.boolean  "is_shared",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comfy_cms_snippets", ["site_id", "identifier"], name: "index_comfy_cms_snippets_on_site_id_and_identifier", unique: true, using: :btree
  add_index "comfy_cms_snippets", ["site_id", "position"], name: "index_comfy_cms_snippets_on_site_id_and_position", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "favourites", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "favouriteable_type"
    t.integer  "favouriteable_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "homepage_sliders", force: :cascade do |t|
    t.integer  "site_configuration_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "landings", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "main_heading"
    t.string   "sub_heading"
    t.text     "description"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "bg_image_file_name"
    t.string   "bg_image_content_type"
    t.integer  "bg_image_file_size"
    t.datetime "bg_image_updated_at"
    t.string   "landing_type"
  end

  create_table "listing_images", force: :cascade do |t|
    t.string  "imageable_type"
    t.integer "imageable_id"
    t.string  "image_src"
  end

  create_table "listings", force: :cascade do |t|
    t.string   "a_c",                   limit: 100
    t.string   "acres",                 limit: 100
    t.text     "ad_text"
    t.string   "addr",                  limit: 100
    t.string   "all_inc",               limit: 100
    t.string   "apt_num",               limit: 100
    t.string   "area",                  limit: 100
    t.string   "area_code",             limit: 100
    t.integer  "ass_year"
    t.integer  "bath_tot",              limit: 2
    t.integer  "br",                    limit: 2
    t.integer  "br_plus",               limit: 2
    t.string   "bsmt1_out",             limit: 100
    t.string   "bsmt2_out",             limit: 100
    t.string   "cable",                 limit: 100
    t.string   "cac_inc",               limit: 100
    t.string   "central_vac",           limit: 100
    t.string   "cert_lvl",              limit: 100
    t.string   "comel_inc",             limit: 100
    t.string   "community",             limit: 100
    t.string   "community_code",        limit: 100
    t.string   "comp_pts",              limit: 100
    t.string   "constr1_out",           limit: 100
    t.string   "constr2_out",           limit: 100
    t.string   "county",                limit: 100
    t.string   "cross_st",              limit: 255
    t.string   "den_fr",                limit: 100
    t.decimal  "depth",                             precision: 6, scale: 2
    t.string   "disp_addr",             limit: 100
    t.integer  "DOM",                   limit: 8
    t.string   "drive",                 limit: 100
    t.string   "elec",                  limit: 100
    t.string   "elevator",              limit: 100
    t.string   "energy_cert",           limit: 100
    t.text     "extras"
    t.string   "farm_agri",             limit: 100
    t.string   "fpl_num",               limit: 100
    t.decimal  "front_ft",                          precision: 8, scale: 2
    t.string   "fuel",                  limit: 100
    t.string   "furnished",             limit: 100
    t.integer  "gar_spaces"
    t.string   "gar_type",              limit: 100
    t.string   "gas",                   limit: 100
    t.string   "green_pis",             limit: 100
    t.string   "handi_equipped",        limit: 100
    t.string   "heat_inc",              limit: 100
    t.string   "heating",               limit: 100
    t.string   "hydro_inc",             limit: 100
    t.string   "irreg",                 limit: 100
    t.integer  "kit_plus",              limit: 2
    t.string   "laundry",               limit: 100
    t.string   "laundry_lev",           limit: 100
    t.string   "lease_term",            limit: 100
    t.string   "level1",                limit: 100
    t.string   "level10",               limit: 100
    t.string   "level11",               limit: 100
    t.string   "level12",               limit: 100
    t.string   "level2",                limit: 100
    t.string   "level3",                limit: 100
    t.string   "level4",                limit: 100
    t.string   "level5",                limit: 100
    t.string   "level6",                limit: 100
    t.string   "level7",                limit: 100
    t.string   "level8",                limit: 100
    t.string   "level9",                limit: 100
    t.string   "lotsz_code",            limit: 100
    t.integer  "lp_dol"
    t.string   "ml_num",                limit: 100
    t.integer  "mmap_col",              limit: 2
    t.integer  "mmap_page"
    t.string   "mmap_row",              limit: 100
    t.string   "municipality",          limit: 100
    t.string   "municipality_code",     limit: 100
    t.string   "municipality_district", limit: 100
    t.integer  "num_kit",               limit: 2
    t.string   "occ",                   limit: 100
    t.string   "oth_struc1_out",        limit: 100
    t.string   "oth_struc2_out",        limit: 100
    t.string   "outof_area",            limit: 100
    t.string   "parcel_id",             limit: 100
    t.integer  "park_chgs",             limit: 8
    t.integer  "park_spcs"
    t.string   "pay_freq",              limit: 100
    t.datetime "pix_updt"
    t.string   "pool",                  limit: 100
    t.string   "prkg_inc",              limit: 100
    t.string   "prop_feat1_out",        limit: 100
    t.string   "prop_feat2_out",        limit: 100
    t.string   "prop_feat3_out",        limit: 100
    t.string   "prop_feat4_out",        limit: 100
    t.string   "prop_feat5_out",        limit: 100
    t.string   "prop_feat6_out",        limit: 100
    t.string   "pvt_ent",               limit: 100
    t.string   "retirement",            limit: 100
    t.string   "rltr",                  limit: 100
    t.string   "rm1_dc1_out",           limit: 100
    t.string   "rm1_dc2_out",           limit: 100
    t.string   "rm1_dc3_out",           limit: 100
    t.integer  "rm1_len",               limit: 8
    t.string   "rm1_out",               limit: 100
    t.integer  "rm1_wth",               limit: 8
    t.string   "rm10_dc1_out",          limit: 100
    t.string   "rm10_dc2_out",          limit: 100
    t.string   "rm10_dc3_out",          limit: 100
    t.integer  "rm10_len",              limit: 8
    t.string   "rm10_out",              limit: 100
    t.integer  "rm10_wth",              limit: 8
    t.string   "rm11_dc1_out",          limit: 100
    t.string   "rm11_dc2_out",          limit: 100
    t.string   "rm11_dc3_out",          limit: 100
    t.integer  "rm11_len",              limit: 8
    t.string   "rm11_out",              limit: 100
    t.integer  "rm11_wth",              limit: 8
    t.string   "rm12_dc1_out",          limit: 100
    t.string   "rm12_dc2_out",          limit: 100
    t.string   "rm12_dc3_out",          limit: 100
    t.integer  "rm12_len",              limit: 8
    t.string   "rm12_out",              limit: 100
    t.integer  "rm12_wth",              limit: 8
    t.string   "rm2_dc1_out",           limit: 100
    t.string   "rm2_dc2_out",           limit: 100
    t.string   "rm2_dc3_out",           limit: 100
    t.integer  "rm2_len",               limit: 8
    t.string   "rm2_out",               limit: 100
    t.integer  "rm2_wth",               limit: 8
    t.string   "rm3_dc1_out",           limit: 100
    t.string   "rm3_dc2_out",           limit: 100
    t.string   "rm3_dc3_out",           limit: 100
    t.integer  "rm3_len",               limit: 8
    t.string   "rm3_out",               limit: 100
    t.integer  "rm3_wth",               limit: 8
    t.string   "rm4_dc1_out",           limit: 100
    t.string   "rm4_dc2_out",           limit: 100
    t.string   "rm4_dc3_out",           limit: 100
    t.integer  "rm4_len",               limit: 8
    t.string   "rm4_out",               limit: 100
    t.integer  "rm4_wth",               limit: 8
    t.string   "rm5_dc1_out",           limit: 100
    t.string   "rm5_dc2_out",           limit: 100
    t.string   "rm5_dc3_out",           limit: 100
    t.integer  "rm5_len",               limit: 8
    t.string   "rm5_out",               limit: 100
    t.integer  "rm5_wth",               limit: 8
    t.string   "rm6_dc1_out",           limit: 100
    t.string   "rm6_dc2_out",           limit: 100
    t.string   "rm6_dc3_out",           limit: 100
    t.integer  "rm6_len",               limit: 8
    t.string   "rm6_out",               limit: 100
    t.integer  "rm6_wth",               limit: 8
    t.string   "rm7_dc1_out",           limit: 100
    t.string   "rm7_dc2_out",           limit: 100
    t.string   "rm7_dc3_out",           limit: 100
    t.integer  "rm7_len",               limit: 8
    t.string   "rm7_out",               limit: 100
    t.integer  "rm7_wth",               limit: 8
    t.string   "rm8_dc1_out",           limit: 100
    t.string   "rm8_dc2_out",           limit: 100
    t.string   "rm8_dc3_out",           limit: 100
    t.integer  "rm8_len",               limit: 8
    t.string   "rm8_out",               limit: 100
    t.integer  "rm8_wth",               limit: 8
    t.string   "rm9_dc1_out",           limit: 100
    t.string   "rm9_dc2_out",           limit: 100
    t.string   "rm9_dc3_out",           limit: 100
    t.integer  "rm9_len",               limit: 8
    t.string   "rm9_out",               limit: 100
    t.integer  "rm9_wth",               limit: 8
    t.integer  "rms",                   limit: 2
    t.integer  "rooms_plus",            limit: 2
    t.string   "s_r",                   limit: 100
    t.string   "sewer",                 limit: 100
    t.string   "spec_des1_out",         limit: 100
    t.string   "spec_des2_out",         limit: 100
    t.string   "spec_des3_out",         limit: 100
    t.string   "spec_des4_out",         limit: 100
    t.string   "spec_des5_out",         limit: 100
    t.string   "spec_des6_out",         limit: 100
    t.string   "sqft",                  limit: 100
    t.string   "st",                    limit: 100
    t.string   "st_dir",                limit: 100
    t.string   "st_num",                limit: 100
    t.string   "st_sfx",                limit: 100
    t.string   "status",                limit: 100
    t.string   "style",                 limit: 100
    t.integer  "taxes",                 limit: 8
    t.string   "timestamp",             limit: 100
    t.datetime "timestamp_sql"
    t.integer  "tv",                    limit: 8
    t.string   "type_own_srch",         limit: 100
    t.string   "type_own1_out",         limit: 100
    t.string   "uffi",                  limit: 100
    t.string   "util_cable",            limit: 100
    t.string   "util_tel",              limit: 100
    t.string   "vend_pis",              limit: 100
    t.string   "water",                 limit: 100
    t.string   "water_inc",             limit: 100
    t.string   "waterfront",            limit: 100
    t.integer  "wcloset_p1",            limit: 2
    t.integer  "wcloset_p2",            limit: 2
    t.integer  "wcloset_p3",            limit: 2
    t.integer  "wcloset_p4",            limit: 2
    t.integer  "wcloset_p5",            limit: 2
    t.integer  "wcloset_t1",            limit: 2
    t.string   "wcloset_t1lvl",         limit: 100
    t.integer  "wcloset_t2",            limit: 2
    t.string   "wcloset_t2lvl",         limit: 100
    t.integer  "wcloset_t3",            limit: 2
    t.string   "wcloset_t3lvl",         limit: 100
    t.integer  "wcloset_t4",            limit: 2
    t.string   "wcloset_t4lvl",         limit: 100
    t.integer  "wcloset_t5",            limit: 2
    t.string   "wcloset_t5lvl",         limit: 100
    t.string   "wtr_suptyp",            limit: 100
    t.integer  "yr"
    t.string   "yr_built",              limit: 100
    t.string   "zip",                   limit: 100
    t.string   "zoning",                limit: 100
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "deleted_at"
    t.text     "fields_to_show"
    t.string   "share_perc",            limit: 100
    t.string   "patio_ter",             limit: 100
    t.string   "bldg_amen1_out",        limit: 100
    t.string   "bldg_amen2_out",        limit: 100
    t.string   "bldg_amen3_out",        limit: 100
    t.string   "bldg_amen4_out",        limit: 100
    t.string   "bldg_amen5_out",        limit: 100
    t.string   "bldg_amen6_out",        limit: 100
    t.string   "insur_bldg",            limit: 100
    t.integer  "corp_num"
    t.string   "condo_corp",            limit: 100
    t.string   "cond_txinc",            limit: 100
    t.string   "ens_lndry",             limit: 100
    t.string   "condo_exp",             limit: 100
    t.integer  "gar"
    t.string   "stories",               limit: 100
    t.string   "locker",                limit: 100
    t.string   "locker_num",            limit: 100
    t.integer  "maint"
    t.string   "park_lgl_desc1",        limit: 100
    t.string   "park_lgl_desc2",        limit: 100
    t.string   "park_spc1",             limit: 100
    t.string   "park_spc2",             limit: 100
    t.string   "park_desig",            limit: 100
    t.string   "park_desig_2",          limit: 100
    t.string   "park_fac",              limit: 100
    t.string   "pets",                  limit: 100
    t.string   "prop_mgmt",             limit: 100
    t.string   "unit_num",              limit: 100
    t.string   "listing_type",          limit: 100
    t.string   "visibility",            limit: 100
    t.boolean  "featured"
    t.integer  "listing_images_count"
    t.string   "slug"
  end

  add_index "listings", ["slug"], name: "index_listings_on_slug", using: :btree

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id", using: :btree
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type", using: :btree

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type", using: :btree
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type", using: :btree
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type", using: :btree

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type", using: :btree

  create_table "menu_items", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "menu_location_id"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_locations", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prospect_matches", force: :cascade do |t|
    t.string   "title"
    t.string   "city"
    t.string   "property_types"
    t.integer  "min_price"
    t.integer  "max_price"
    t.string   "beds"
    t.string   "baths"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.float    "lat"
    t.float    "long"
    t.integer  "radius"
  end

  create_table "site_configurations", force: :cascade do |t|
    t.float    "rebate_percent"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "privacy_content"
    t.text     "terms_content"
    t.text     "cookies_content"
    t.text     "about_content"
    t.text     "sellers_content"
    t.text     "buyers_content"
    t.text     "resources_content"
    t.text     "contact_content"
    t.string   "blog_url"
    t.string   "facebook_url"
    t.string   "twitter_url"
    t.string   "contact_us_email"
    t.string   "meta_description"
    t.string   "meta_keywords"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "faye_token"
    t.string   "address"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.string   "postal_code"
    t.string   "phone_number"
    t.string   "provider"
    t.string   "uid"
    t.boolean  "unsubscribe_all"
    t.boolean  "newsletter_subscribed"
    t.boolean  "admin"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "visits", id: :uuid, force: :cascade do |t|
    t.uuid     "visitor_id"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
  end

  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
end
