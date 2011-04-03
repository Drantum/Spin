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
   Setting.create(:name => "site_title", :value => "Spin", :setting_type => "blog", :description => "The Title of your Site", :item_type => "string")
   Setting.create(:name => "site_description", :value => "Welcome to My Spin Blog!", :setting_type => "blog", :description => "The Description of your site", :item_type => "string")
   Setting.create(:name => "site_keywords", :value => "Spin, ruby on rails, ror, opensource blog, blog software, hulihan applications, ruby, free blog", :setting_type => "blog", :description => "Keywords used with your site, for searching, etc.", :item_type => "string")
   Setting.create(:name => "enable_site_title", :value => "1", :setting_type => "blog", :description => "Do you want your site title to appear at the top of your blog?", :item_type => "string")
   Setting.create(:name => "posts_per_page", :value => "10", :setting_type => "blog", :description => "How many posts to show per page", :item_type => "string")
   Setting.create(:name => "archive_months_to_show", :value => "12", :setting_type => "blog", :description => "How many months of archived posts should be shown", :item_type => "string") 
  end

  def self.down
    drop_table :settings
  end
end
