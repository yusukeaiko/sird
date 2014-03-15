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

ActiveRecord::Schema.define(version: 20140304152038) do

  create_table "countries", force: true do |t|
    t.string   "numeric",                 null: false
    t.string   "alpha3",                  null: false
    t.string   "alpha2",                  null: false
    t.string   "country_name",            null: false
    t.string   "country_name_ja"
    t.string   "area"
    t.string   "administrative_division"
    t.string   "flag_filename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["alpha2"], name: "index_countries_on_alpha2", unique: true
  add_index "countries", ["alpha3"], name: "index_countries_on_alpha3", unique: true
  add_index "countries", ["numeric"], name: "index_countries_on_numeric", unique: true

  create_table "registries", force: true do |t|
    t.string   "registry",                   null: false
    t.string   "regional_internet_registry", null: false
    t.string   "cover_area",                 null: false
    t.string   "uri",                        null: false
    t.string   "data_uri",                   null: false
    t.string   "data_file",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "registries", ["registry"], name: "index_registries_on_registry", unique: true

  create_table "statistics_records", force: true do |t|
    t.integer  "registry_id",    null: false
    t.integer  "country_id"
    t.string   "data_type"
    t.string   "start_addr"
    t.string   "end_addr"
    t.string   "value"
    t.integer  "prefix"
    t.string   "date"
    t.string   "status",         null: false
    t.string   "extensions"
    t.string   "start_addr_dec"
    t.string   "end_addr_dec"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statistics_summaries", force: true do |t|
    t.integer  "registry_id", null: false
    t.string   "data_type",   null: false
    t.integer  "count"
    t.string   "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statistics_summaries", ["registry_id"], name: "index_statistics_summaries_on_registry_id"

  create_table "statistics_versions", force: true do |t|
    t.string   "version",     null: false
    t.integer  "registry_id", null: false
    t.integer  "serial",      null: false
    t.integer  "records",     null: false
    t.string   "startdate"
    t.string   "enddate"
    t.string   "UTCoffset"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statistics_versions", ["registry_id"], name: "index_statistics_versions_on_registry_id"

end
