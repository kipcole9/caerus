class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.integer     :level, :limit => 2, :default => 0
      t.integer     :account_id
      t.integer     :object_id
      t.string      :object_type
      t.integer     :user_id
      t.string      :ip_address
      t.string      :message
      t.timestamps
    end
    add_index :logs, :account_id, :name => "index_logs_on_account_id"
    add_index :logs, [:object_id, :object_type], :name => "index_logs_on_object_id_and_object_type"
    add_index :logs, :user_id, :name => "index_logs_on_user_id"
  end

  def self.down
    drop_table :logs
  end
end
