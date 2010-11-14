class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.column :user_id, :int
      t.column :created_at, :datetime #this will get populated automatically
      t.column :log_type, :string
      t.column :log, :text
    end
  end

  def self.down
    drop_table :logs
  end
end
