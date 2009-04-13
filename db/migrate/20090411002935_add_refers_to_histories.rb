class AddRefersToHistories < ActiveRecord::Migration
  def self.up
    add_column :histories, :refers_to, :string
  end

  def self.down
    remove_column :histories, :refers_to
  end
end
