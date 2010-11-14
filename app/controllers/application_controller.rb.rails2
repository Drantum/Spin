# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_blog_session_id'
  protect_from_forgery  # protect against site forgery


  before_filter :load_settings, :except => [ :login] #load settings
  
  def get_setting(name) # get a setting
   @setting = Setting.find(:first, :conditions => ["name = ?", name], :limit => 1 )
   return @setting.value
  end

 def get_setting_bool(name) # get a setting from the database return true or false depending on "1" or "0"
   setting = Setting.find(:first, :conditions => ["name = ?", name], :limit => 1 )
   if setting.value == "1"
     return true
   else # not true
     return false
   end
 end 
 
 def load_settings #load in settings from db
   @site_title = get_setting("site_title")
   @site_desc = get_setting("site_description")
   @meta_title = get_setting("site_title")
   @meta_keywords = get_setting("site_keywords")
   @meta_desc = get_setting("site_description")
 end    
end
