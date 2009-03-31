class CreateRecipients < ActiveRecord::Migration
  def self.up
    create_table :recipients do |t|
      t.string    :salutation
      t.string    :first_name
      t.string    :last_name
      t.string    :email
      t.timestamps
    end
  end

  def self.down
    drop_table :recipients
  end
end
