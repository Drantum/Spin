class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.column :title, :string
      t.column :content, :text
      t.column :user_id, :integer, :default => 1
      t.column :created_at, :datetime#this will get populated automatically
      t.column :updated_at, :datetime#this will get populated automatically
    end
   Post.create(:title => "First Post", :content => "Hi there! This is my first post. I hope everyone is doing well!")
  end

  def self.down
    drop_table :posts
  end
end
