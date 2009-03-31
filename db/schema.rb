# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090331031146) do

  create_table "accounts", :force => true do |t|
    t.string  "name"
    t.string  "timezone",                 :limit => 40
    t.string  "company_name"
    t.string  "calendar_type",            :limit => 20, :default => "gregorian"
    t.string  "calendar_month",           :limit => 10, :default => "january"
    t.string  "calendar_begins_or_ends",  :limit => 10, :default => "begins"
    t.string  "calendar_first_or_last",   :limit => 5,  :default => "first"
    t.string  "calendar_day_of_week",     :limit => 10, :default => "sunday"
    t.string  "calendar_first_or_full",   :limit => 10, :default => "first"
    t.boolean "calendar_use_ending_year",               :default => false
    t.string  "calendar_quarter_type",    :limit => 3,  :default => "445"
    t.string  "currency",                 :limit => 3
    t.string  "description"
    t.string  "title"
  end

  create_table "addresses", :force => true do |t|
    t.integer "contact_id"
    t.string  "street_1"
    t.string  "street_2"
    t.string  "city"
    t.string  "country"
  end

  add_index "addresses", ["contact_id"], :name => "index_addresses_on_contact_id"

  create_table "affiliations", :force => true do |t|
    t.integer "contact_id"
    t.string  "type",         :limit => 10
    t.integer "affiliate_id"
  end

  add_index "affiliations", ["affiliate_id"], :name => "index_affiliations_on_affiliate_id"
  add_index "affiliations", ["contact_id"], :name => "index_affiliations_on_contact_id"

  create_table "articles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bounces", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.string   "url"
    t.string   "visitor",    :limit => 20
    t.string   "session",    :limit => 20
    t.datetime "tracked_at"
  end

  create_table "campaigns", :force => true do |t|
    t.integer  "site_id"
    t.string   "name"
    t.text     "description"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clicked_emails", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.integer  "count",         :limit => 8,  :default => 0, :null => false
    t.string   "campaign_name"
    t.string   "ip_address",    :limit => 20
    t.string   "country",       :limit => 20
    t.string   "locality",      :limit => 20
    t.datetime "tracked_at"
  end

  create_table "clicks", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "responder_id"
    t.string   "browser"
    t.string   "ip_address"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clicks_through", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.string   "visitor",    :limit => 20
    t.string   "session",    :limit => 20
    t.string   "url"
    t.datetime "tracked_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "given_name"
    t.string   "family_name"
    t.string   "salutation",         :limit => 30
    t.string   "prefix",             :limit => 20
    t.string   "suffix",             :limit => 20
    t.string   "nickname",           :limit => 20
    t.string   "greeting",           :limit => 20
    t.string   "address_as",         :limit => 50
    t.string   "name",               :limit => 100
    t.string   "locale",             :limit => 50
    t.string   "timezone",           :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "role"
    t.string   "organization"
    t.string   "profile"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
  end

  add_index "contacts", ["family_name"], :name => "index_contacts_on_family_name"
  add_index "contacts", ["given_name"], :name => "index_contacts_on_given_name"
  add_index "contacts", ["name"], :name => "index_contacts_on_name"

  create_table "emails", :force => true do |t|
    t.integer "contact_id"
    t.string  "address"
    t.string  "kind",       :limit => 10
    t.boolean "preferred",                :default => false
  end

  add_index "emails", ["contact_id"], :name => "index_emails_on_contact_id"

  create_table "entry_pages", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.string   "url"
    t.datetime "tracked_at"
  end

  create_table "instant_messengers", :force => true do |t|
    t.integer "contact_id"
    t.string  "type",       :limit => 10
    t.string  "address"
  end

  add_index "instant_messengers", ["contact_id"], :name => "index_instant_messengers_on_contact_id"

  create_table "landing_pages", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.string   "url"
    t.datetime "tracked_at"
  end

  create_table "logged_exceptions", :force => true do |t|
    t.string   "exception_class"
    t.string   "controller_name"
    t.string   "action_name"
    t.text     "message"
    t.text     "backtrace"
    t.text     "environment"
    t.text     "request"
    t.datetime "created_at"
  end

  create_table "logs", :force => true do |t|
    t.integer  "level",       :limit => 2, :default => 0
    t.integer  "account_id"
    t.integer  "object_id"
    t.string   "object_type"
    t.integer  "user_id"
    t.string   "ip_address"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logs", ["account_id"], :name => "index_logs_on_account_id"
  add_index "logs", ["object_id", "object_type"], :name => "index_logs_on_object_id_and_object_type"
  add_index "logs", ["user_id"], :name => "index_logs_on_user_id"

  create_table "mailings", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "recipient_id"
    t.datetime "sent_at"
    t.string   "status"
  end

  create_table "new_visitors", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.string   "visitor",    :limit => 20
    t.datetime "tracked_at"
  end

  create_table "opened_emails", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.integer  "count",         :limit => 8,  :default => 0, :null => false
    t.string   "campaign_name"
    t.string   "ip_address",    :limit => 20
    t.string   "country",       :limit => 20
    t.string   "locality",      :limit => 20
    t.datetime "tracked_at"
  end

  create_table "page_views", :force => true do |t|
    t.integer  "site_id"
    t.integer  "views",      :limit => 8,  :default => 0, :null => false
    t.string   "url"
    t.string   "country",    :limit => 20
    t.string   "locality",   :limit => 20
    t.string   "ip_address", :limit => 20
    t.datetime "tracked_at"
  end

  create_table "page_views_per_visit", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.integer  "views",      :limit => 8,  :default => 0, :null => false
    t.string   "visitor",    :limit => 20
    t.string   "session",    :limit => 20
    t.datetime "tracked_at"
  end

  create_table "phones", :force => true do |t|
    t.integer "contact_id"
    t.string  "kind",       :limit => 10
    t.string  "number",     :limit => 20
  end

  add_index "phones", ["contact_id"], :name => "index_phones_on_contact_id"

  create_table "recipients", :force => true do |t|
    t.string   "salutation"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repeat_visitors", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.integer  "count",      :limit => 8,  :default => 0, :null => false
    t.string   "visitor",    :limit => 20
    t.datetime "tracked_at"
  end

  create_table "return_visitors", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.string   "visitor",    :limit => 20
    t.datetime "tracked_at"
  end

  create_table "sites", :force => true do |t|
    t.integer  "account_id"
    t.string   "tracker"
    t.string   "base_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "tracks", :force => true do |t|
    t.integer  "site_id"
    t.string   "site_code",        :limit => 20
    t.string   "visitor",          :limit => 20
    t.string   "session",          :limit => 20
    t.string   "page_title"
    t.string   "screen_size",      :limit => 10
    t.string   "color_depth",      :limit => 5
    t.string   "language",         :limit => 10
    t.string   "charset",          :limit => 10
    t.string   "flash_version",    :limit => 10
    t.string   "unique_request",   :limit => 20
    t.string   "campaign_name"
    t.string   "campaign_source"
    t.string   "campaign_medium"
    t.string   "campaign_content"
    t.string   "url"
    t.string   "ip_address",       :limit => 20
    t.string   "referrer"
    t.string   "user_agent"
    t.string   "browser"
    t.string   "browser_version"
    t.string   "country",          :limit => 20
    t.string   "region",           :limit => 20
    t.string   "locality",         :limit => 20
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "tracked_at"
    t.datetime "geocoded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count"
    t.integer  "duration"
    t.boolean  "outbound",                       :default => false
    t.integer  "visit"
    t.integer  "view"
    t.datetime "previous_session"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "account_id"
    t.string   "timezone",                  :limit => 50
    t.boolean  "account_admin",                            :default => false
    t.string   "locale",                    :limit => 10
    t.string   "first_name"
    t.string   "last_name"
    t.string   "ip_address",                :limit => 50
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "visit_duration", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.integer  "duration",   :limit => 8
    t.string   "visitor",    :limit => 20
    t.string   "session",    :limit => 20
    t.datetime "tracked_at"
  end

  create_table "visitors", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.integer  "count",      :limit => 8,  :default => 0, :null => false
    t.string   "visitor",    :limit => 20
    t.datetime "tracked_at"
  end

  create_table "visits", :id => false, :force => true do |t|
    t.integer  "site_id"
    t.integer  "visits",     :limit => 8,  :default => 0, :null => false
    t.string   "visitor",    :limit => 20
    t.string   "session",    :limit => 20
    t.datetime "tracked_at"
  end

  create_table "websites", :force => true do |t|
    t.integer "contact_id"
    t.string  "kind",       :limit => 10
    t.string  "url"
  end

  add_index "websites", ["contact_id"], :name => "index_websites_on_contact_id"

end
