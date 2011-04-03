class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :name, :string
      t.column :email, :string 
      t.column :website, :string 
      t.column :comment_id, :int # for replies to comments 
      t.column :post_id, :int
      t.column :ip, :string
      t.column :comment, :text
      t.column :created_at, :datetime#this will get populated automatically
      t.column :updated_at, :datetime#this will get populated automatically
    end
    
    Comment.create(:name => "Bob Jones", :comment => "I like this post!", :post_id => 1)
  end
  
  def self.down
    drop_table :comments
  end
end
