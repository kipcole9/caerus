class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.belongs_to  :account
      t.string      :name
      t.text        :description
      
      # For nested set
      t.integer     :lft
      t.integer     :rgt
      t.integer     :parent_id
      
      # For tracking
      t.integer     :created_by
      t.integer     :updated_by
      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
