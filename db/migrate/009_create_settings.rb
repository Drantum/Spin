class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.column :name, :string
      t.column :title, :string
      t.column :setting_type, :string
      t.column :value, :string
      t.column :description, :string
      t.column :item_type, :string
    end
   #populate default settings
   Setting.create(:name => "site_title", :value => "My Amethyst Blog", :setting_type => "blog", :description => "The Title of your Site", :item_type => "string")
   Setting.create(:name => "site_description", :value => "Welcome to My Amethyst Blog!", :setting_type => "blog", :description => "The Description of your site", :item_type => "string")
   Setting.create(:name => "site_keywords", :value => "amethyst blog, amethyst, ruby on rails, ror, opensource blog, blog software, hulihan applications, ruby, free blog", :setting_type => "blog", :description => "Keywords used with your site, for searching, etc.", :item_type => "string")
   Setting.create(:name => "enable_site_title", :value => "1", :setting_type => "blog", :description => "Do you want your site title to appear at the top of your blog?", :item_type => "string")
   Setting.create(:name => "posts_per_page", :value => "10", :setting_type => "blog", :description => "How many posts to show per page", :item_type => "string")
   Setting.create(:name => "archive_months_to_show", :value => "12", :setting_type => "blog", :description => "How many months of archived posts should be shown", :item_type => "string")
   Setting.create(:name => "enable_menu_archive", :value => "1", :setting_type => "blog", :description => "Will the archive menu be visible?", :item_type => "bool")
   Setting.create(:name => "enable_menu_search", :value => "1", :setting_type => "blog", :description => "Will the archive menu be visible?", :item_type => "bool")
   Setting.create(:name => "enable_menu_tools", :value => "0", :setting_type => "blog", :description => "Will the archive menu be visible?", :item_type => "bool")
   Setting.create(:name => "enable_menu_other", :value => "1", :setting_type => "blog", :description => "Will the archive menu be visible?", :item_type => "bool")
   Setting.create(:name => "item_thumbnail_width", :title => "Item Thumbnail Width",  :value => "100", :setting_type => "Item Object", :description => "This is the width(in pixels) of the thumbnails that are generated.", :item_type => "string")
   Setting.create(:name => "item_thumbnail_height", :title => "Item Thumbnail Height",  :value => "100", :setting_type => "Item Object", :description => "TThis is the height(in pixels) of the thumbnails that are generated.", :item_type => "string")        
   Setting.create(:name => "resize_item_images", :title => "Uniform Item Image Size",  :value => "0", :setting_type => "Item Object", :description => "Enable this if you would like all the images that are added to images resized to a particular size(you can choose the size below).", :item_type => "bool")
   Setting.create(:name => "item_image_width", :title => "Item Image Width",  :value => "500", :setting_type => "Item Object", :description => "This is the width you want your images(in pixels) to be automatically resized to. Only used if Uniform Item Image Size is turned on.", :item_type => "string")
   Setting.create(:name => "item_image_height", :title => "Item Image Height",  :value => "500", :setting_type => "Item Object", :description => "This is the height you want your images(in pixels) to be automatically resized to. Only used if Uniform Item Image Size is turned on.", :item_type => "string")    
  end

  def self.down
    drop_table :settings
  end
end
