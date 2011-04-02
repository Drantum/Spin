class AdminController < ApplicationController
before_filter :authenticate_user!

  uses_tiny_mce( :options => {
                              :theme => 'advanced',
                              :theme_advanced_resizing => true,
                              :theme_advanced_resize_horizontal => false,
                              :plugins => %w{ table advimage style },
                              :theme_advanced_toolbar_location => "top",
                              
                              :theme_advanced_buttons1_add => %w{ forecolor backcolor forecolorpicker backcolorpicker },
                              :theme_advanced_buttons2_add => %w{ bullist numlist styleprops},                              
                              :theme_advanced_buttons3_add =>  %w{tablecontrols},
                              :forced_root_block => false,
                              :relative_urls => false           
                            },
                :only => [:new, :edit]  # which actions to load tiny_mce
               )

  def list    
	 @posts = Post.order("created_at DESC")	
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    @post.user_id = session[:user][:id] # save the user that posted this
    if @post.save
      flash[:notice] = 'Post was successfully created.'
      redirect_to :action => 'list'
    else
      flash[:notice] = get_errors_for(@post) # get any errors 
      render :action => 'new'
    end
  end

  def create_tag
   @tag = Tag.new(params[:tag])
   if @tag.save
     flash[:notice] = 'Tag was successfully added.'
   else
     flash[:notice] = get_errors_for(@tag)  # get any errors
   end
    # render :action => 'edit', :id => params[:tag][:post_id]
     redirect_to :action => 'edit', :id => params[:tag][:post_id]
  end

  def edit
    @post = Post.find(params[:id], :limit => 1)
    # @tags = Tag.find(:all, :conditions => ["post_id = ?", params[:id] ], :limit => 100)
	 @tags = Tag.where("post_id = ?", params[:id] ).limit(100)
    # @comments = Comment.find(:all, :conditions => ["post_id = ?", params[:id] ], :limit => 500)
	 @comments = Comment.where("post_id = ?", params[:id]).limit(500)
  end

  def edit_settings
   @settings = Setting.find(:all)
  end
 
  def user
    @user = User.find(:all) 
  end 

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post was successfully updated.'
      redirect_to :action => 'edit', :id => @post
    else
      redirect_to :action => 'edit', :id => @post.id
    end
  end
 
  def update_settings
   flash[:notice] = ""
   params[:setting].each do |name, value|
    # Dave: here were are querying the db once for EVERY setting in the table, just to get the setting name.
    # This is a little costly, the alternative being a find(:all) that is indexed with a integer-style counter
    # ie: @settings[counter], but the problem is that if the settings in the html form are listed in any
    # different order, updating will do nothing, since the form setting and the indexed find(:all) won't match.
    # In the long run, this won't be too bad, since the size of the settings table shouldn't be very large(< 100)
    @setting = Setting.find(:first, :conditions => ["name = ?", name])
    if @setting.value != value # the value of the setting has changed
     if @setting.update_attribute("value", value) # update the setting
      flash[:notice] << "The setting(#{name}) was updated!"
     else
      flash[:notice] << "<font color=red>The setting(#{name}) failed updating!</font>"
     end
    else
     #flash[:notice] << "<font color=grey>The Setting(#{name}) has not changed.</font>"
    end
   end
    redirect_to :action => "index"
  end

  def destroy    
	 @comments = Comment.where("post_id = ?", params[:id])
    @comments.each do |comment|
     comment.destroy # destroy all posts
    end
    Post.find(params[:id]).destroy    
    flash[:notice] = "Post Deleted"
    redirect_to :action => 'list'
  end
 
  def destroy_comment
   @comment = Comment.find(params[:id], :limit => 1)
   @comment.destroy # delete the comment
   redirect_to :action => "edit", :id => params[:post_id]
   #render :text => params[:post_id]
  end

  def destroy_tag
   @tag = Tag.find(params[:id], :limit => 1)
   @tag.destroy # delete the comment
   flash[:notice] = "Tag destroyed!"
   redirect_to :action => "edit", :id => params[:post_id]
  end

	def widget
	 @widgets = Widget.order("row")	
	end

	def update_widgets
	 # This must change because it is still a lot of query
	 params[:title].each do |widget_id, value|
   @widget = Widget.find(:first, :conditions => ["id_widget = ?", widget_id])
    if @widget.title != value # the value of the setting has changed
     if @widget.update_attribute("title", value) # update the setting
     end
    end
   end
	 params[:content].each do |widget_id, value|
   @widget = Widget.find(:first, :conditions => ["id_widget = ?", widget_id])
    if @widget.content != value # the value of the setting has changed
     if @widget.update_attribute("content", value) # update the setting
     end
    end
   end
	 params[:css].each do |widget_id, value|
   @widget = Widget.find(:first, :conditions => ["id_widget = ?", widget_id])
    if @widget.css != value # the value of the setting has changed
     if @widget.update_attribute("css", value) # update the setting
     end
    end
   end
	 params[:active].each do |widget_id, value|
   @widget = Widget.find(:first, :conditions => ["id_widget = ?", widget_id])
    if @widget.active != value # the value of the setting has changed
     if @widget.update_attribute("active", value) # update the setting
     end
    end
	 end
		redirect_to :action => "widget"
	end

	def themes
   @themes = Array.new
   themes_dir = File.join(RAILS_ROOT + "/public/themes/") # the folder containing the themes
   Dir.new(themes_dir).entries.each do |file|
     if (file.to_s != ".") && (file != "..")
      @themes << file
     end
   end
  end
 
  def delete_theme
    theme = params[:theme]
    if theme == @style # they are trying to delete the active theme
      flash[:failure] = t("notice.invalid_permissions")
      #flash[:failure] = "Sorry, you can't delete the active theme! Please change your theme first."
    else
      themes_dir = RAILS_ROOT + "/public/themes"
      theme_dir = themes_dir + "/" + theme
      theme_config_file = File.join(theme_dir, "theme.yml")
      theme_config = YAML::load(File.open(theme_config_file)) # get theme configuration
           
      themes_layout_dir = RAILS_ROOT + "/app/views/layouts/themes"
      theme_layout_dir = themes_layout_dir + "/" + theme
      FileUtils.rm_rf (theme_dir) if File.exists?(theme_dir)# erase theme directory
      FileUtils.rm_rf (theme_layout_dir) if File.exists?(theme_layout_dir)# erase theme layout directory, if it exists
			flash[:notice] << "The Theme(#{theme}) was delete!"   
  end
    
    redirect_to :action => "themes"
  end
end
