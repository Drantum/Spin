class CreateWidgets < ActiveRecord::Migration
  def self.up
    create_table :widgets do |t|
      t.column :title, :text
      t.column :content, :text
			t.column :css, :text
      t.column :active, :integer, :default => 1
			t.column :row, :integer
    end
   Widget.create(:title => "Archive", :content => "menu_archive", :css => "archive", :row => "2")
   Widget.create(:title => "Search", :content => "menu_search", :css => "search", :row => "3")
   Widget.create(:title => "Feeds", :content => "menu_feeds", :css => "feeds", :row => "1")
   Widget.create(:title => "Tags", :content => "menu_tags", :css => "tags", :row => "4")
  end

  def self.down
    drop_table :widgets
  end
end
