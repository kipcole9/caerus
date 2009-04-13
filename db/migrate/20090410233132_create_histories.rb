class CreateHistories < ActiveRecord::Migration
  def self.up
    create_table :histories do |t|
      t.text          :changes
      t.integer       :created_by
      t.string        :history_type
      t.integer       :history_id
      t.string        :transaction
      t.timestamps
    end
  end

  def self.down
    drop_table :histories
  end
end
