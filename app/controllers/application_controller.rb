class ApplicationController < ActionController::Base
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_blog_session_id'
  protect_from_forgery  # protect against site forgery

end
