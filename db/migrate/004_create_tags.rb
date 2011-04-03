class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
     t.column :post_id ,  :integer
     t.column :name , :text
     t.column :parent_id , :integer, :default => 0
     t.column :created_at , :datetime
    end
    Tag.create(:name => "General", :post_id => 1)
  end

  def self.down
    drop_table :tags
  end
end
