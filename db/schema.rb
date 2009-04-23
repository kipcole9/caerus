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

ActiveRecord::Schema.define(:version => 20090421224844) do

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
    t.integer  "contact_id"
    t.string   "street"
    t.string   "locality"
    t.string   "country"
    t.string   "postalcode", :limit => 10
    t.string   "kind",       :limit => 10
    t.string   "region"
    t.boolean  "preferred",                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "campaigns", :force => true do |t|
    t.integer  "site_id"
    t.string   "name"
    t.text     "description"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "comments", :force => true do |t|
    t.string   "title",            :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "given_name"
    t.string   "family_name"
    t.string   "salutation",         :limit => 30
    t.string   "nickname",           :limit => 20
    t.string   "name",               :limit => 100
    t.string   "locale",             :limit => 50
    t.string   "timezone",           :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "role"
    t.string   "profile"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "organization_id"
    t.string   "gender",             :limit => 10,  :default => "unknown"
    t.string   "role_function",      :limit => 50
    t.string   "role_level",         :limit => 50
    t.string   "name_order",         :limit => 2
    t.string   "honorific_prefix",   :limit => 50
    t.string   "honorific_suffix",   :limit => 50
    t.string   "type"
    t.integer  "employees"
    t.integer  "revenue"
  end

  add_index "contacts", ["family_name"], :name => "index_contacts_on_family_name"
  add_index "contacts", ["given_name"], :name => "index_contacts_on_given_name"
  add_index "contacts", ["name"], :name => "index_contacts_on_name"

  create_table "countries", :force => true do |t|
    t.string  "iso"
    t.string  "name"
    t.string  "printable_name"
    t.string  "iso3"
    t.integer "numcode"
  end

  create_table "emails", :force => true do |t|
    t.integer  "contact_id"
    t.string   "address"
    t.string   "kind",       :limit => 10
    t.boolean  "preferred",                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emails", ["contact_id"], :name => "index_emails_on_contact_id"

  create_table "files", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_members", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  create_table "histories", :force => true do |t|
    t.text     "updates"
    t.integer  "created_by"
    t.string   "historical_type"
    t.integer  "historical_id"
    t.string   "transaction"
    t.datetime "created_at"
    t.string   "actionable_type", :limit => 20
    t.integer  "actionable_id"
  end

  create_table "instant_messengers", :force => true do |t|
    t.integer "contact_id"
    t.string  "type",       :limit => 10
    t.string  "address"
    t.boolean "preferred",                :default => false
  end

  add_index "instant_messengers", ["contact_id"], :name => "index_instant_messengers_on_contact_id"

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

  create_table "mailings", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "recipient_id"
    t.datetime "sent_at"
    t.string   "status"
  end

  create_table "notes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "note"
    t.string   "notable_type", :limit => 20
    t.integer  "notable_id"
    t.integer  "updated_by"
    t.integer  "created_by"
    t.date     "related_date"
  end

  create_table "people", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", :force => true do |t|
    t.integer  "contact_id"
    t.string   "kind",       :limit => 10
    t.string   "number",     :limit => 50
    t.boolean  "preferred",                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "reminders", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "tasks", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_members", :force => true do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.integer  "account_id"
    t.string   "name"
    t.text     "description"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "created_by"
    t.integer  "updated_by"
    t.integer  "contact_id"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "websites", :force => true do |t|
    t.integer  "contact_id"
    t.string   "kind",       :limit => 10
    t.string   "url"
    t.boolean  "preferred",                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "websites", ["contact_id"], :name => "index_websites_on_contact_id"

end
