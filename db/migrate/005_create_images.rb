class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.column :user_id, :integer, :nil => false
      t.column :url, :string, :default => ""
      t.column :thumb_url, :string, :default => ""
      t.column :width, :string, :default => "0"
      t.column :height, :string, :default => "0" 
      t.column :description, :string, :default => "No Description."
      t.string :is_approved, :limit => 1, :default => "0" #has this review been approved by admins?
      t.column :created_at, :datetime#this will get populated automatically
      t.column :updated_at, :datetime#this will get populated automatically
    end
    
    # Create Images Folder
    images_path = "#{RAILS_ROOT}/public/images/uploaded_images"
    FileUtils.mkdir_p(images_path) if !File.exist?(images_path) # remove the folder if it exists 
  end

  def self.down
    drop_table :images
    # Remove Images Folder
    images_path = "#{RAILS_ROOT}/public/images/uploaded_images"
    FileUtils.rm_rf(images_path) if File.exist?(images_path) # remove the folder if it exists    
  end
end