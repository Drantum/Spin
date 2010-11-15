class ApplicationController < ActionController::Base
  before_filter :load_settings #load the settings from db
  
  protected
  def get_setting(name) # get a setting
   # @setting = Setting.find(:first, :conditions => ["name = ?", name], :limit => 1 )
   @setting = Setting.where("name = ?", name).limit(1).first
   if @setting
    return @setting.value
   else
    return false
   end
  end

  def load_settings
	 @style = get_setting("theme")
   @site_title = get_setting("site_title")
   @site_desc = get_setting("site_description")
   @meta_title = get_setting("site_title")
   @meta_keywords = get_setting("site_keywords")
   @meta_desc = get_setting("site_description")
  end
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_blog_session_id'
  protect_from_forgery  # protect against site forgery

end
