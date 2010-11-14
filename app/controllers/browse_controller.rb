class BrowseController < ApplicationController
  before_filter :load_settings #load the settings from db

  include SimpleCaptcha::ControllerHelpers  # Load SimpleCaptcha

  helper :browse # load the view helper
  #caches_page :view # Cache individual post views


  def archive
#   render :text => params.inspect
   @posts_per_page = get_setting("posts_per_page").to_i 
   params[:month] ||= "01"
   params[:year] ||= "01"
   @date = Time.parse("#{params[:year]}/#{params[:month]}")
   @posts = Post.paginate :page => params[:page], :per_page => @posts_per_page, :conditions => ["created_at > ? and created_at < ?", @date.beginning_of_month, @date.end_of_month]
  end

  def create_comment

    if simple_captcha_valid?  
     @comment = Comment.new(params[:comment])
     @comment.ip = "#{request.env['REMOTE_ADDR']}"
     if @comment.save # comment was saved successfully
      flash[:notice] = "Comment Added Successfully. Thanks #{params[:comment][:name]}!<br>"
     end 
    else #Captcha Didn't pass. 
      flash[:notice] = "<font color=red>Your comment wasn't created, because you entered in the wrong code!</font><br>"
    end  
    redirect_to :action => "view", :id => params[:comment][:post_id]
  end


  def index 
   #redirect_to :action => "view_latest"
   @posts_per_page = get_setting("posts_per_page").to_i 
   @posts = Post.paginate :page => params[:page], :per_page => @posts_per_page, :order => "created_at DESC" #paginate via will_paginate
  end
  
  def search
   @search_for = params[:search][:search_for] # what to search for
   @results = Post.find(:all, :conditions => ["title like ? or content like ?", "%#{@search_for}%", "%#{@search_for}%" ], :limit => 100 )
  end

  def view_latest
   @posts_per_page = get_setting("posts_per_page").to_i # how many posts per page should I show?
   examine_url # get all the info from the url you might need(pagination, etc.)
   @posts = Post.find(:all, :offset => @offset, :limit => @posts_per_page, :order => "created_at DESC") 
  end 
  
  def view
   begin
    @post = Post.find(params[:id])
   rescue ActiveRecord::RecordNotFound # If the post doesn't exist...
    logger.info("Invalid post lookup: view_comments - #{params[:id]}")
    flash[:notice] = "<font color=red>No post found with the id: #{params[:id]}"
    #redirect_to :view_latest
   end
   @comments = Comment.find(:all, :conditions => ["post_id = ?", params[:id] ], :limit => 500, :order => "created_at DESC")
   @meta_title = @post.title + " - #{@meta_title}"
   @meta_keywords = @post.content
   @meta_desc = @post.content
  end
  
  def view_posts
   if params[:date] # get time from url
    @time = Time.parse(params[:date].to_s) #convert string to time object
   else # no time specified in url
    @time =  Time.now.beginning_of_month
   end
   @posts_per_page = get_setting("posts_per_page").to_i # how many posts per page should I show?
   examine_url
   @posts = Post.find(:all, :offset => @offset, :limit => @posts_per_page, :order => "created_at DESC", :conditions => ["created_at > ? and created_at < ?", @time , @time.end_of_month] )
  end  

  def view_rss
    headers["Content-Type"] = "application/xml" 
    @posts = Post.find(:all, :order => "created_at DESC", :limit => 10 )
    render :layout => false
  end

  def lookup_tag
   @tag = Tag.find(params[:id]) #look up the tag
   @other_tags = Tag.find(:all, :conditions => ["name = ?", @tag.name], :order => "created_at DESC")
  end

  def tag
   #@tag = Tag.find() #look up the tag
   @other_tags = Tag.find(:all, :conditions => ["name = ?", params[:tag]], :order => "created_at DESC")
  end

protected
  def get_setting(name) # get a setting
   @setting = Setting.find(:first, :conditions => ["name = ?", name], :limit => 1 )
   if @setting
    return @setting.value
   else
    return false
   end
  end

  def examine_url # look at url and get pagination info, etc.
   @offset = params[:offset].to_i ||= 0 # if offset isn't set to anything, set @offset to 0
  end  

  def load_settings
   @site_title = get_setting("site_title")
   @site_desc = get_setting("site_description")
   @meta_title = get_setting("site_title")
   @meta_keywords = get_setting("site_keywords")
   @meta_desc = get_setting("site_description")
  end


end
