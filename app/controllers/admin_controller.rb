class AdminController < ApplicationController
 before_filter :authenticate_login , :except => [:index, :login] #make sure the user is logged in



  uses_tiny_mce( :options => {
                              :theme => 'advanced',
                              :theme_advanced_resizing => true,
                              :theme_advanced_resize_horizontal => false,
                              :plugins => %w{ table advimage style },
                              :theme_advanced_toolbar_location => "top",
                              # Add custom Buttons, see more custom button options here: http://wiki.moxiecode.com/index.php/TinyMCE:Control_reference
                              :theme_advanced_buttons1_add => %w{ forecolor backcolor forecolorpicker backcolorpicker },
                              :theme_advanced_buttons2_add => %w{ bullist numlist styleprops},                              
                              :theme_advanced_buttons3_add =>  %w{tablecontrols},
                              :forced_root_block => false,
                              :relative_urls => false           
                            },
                :only => [:new, :edit]  # which actions to load tiny_mce
               )

	
#------- Actions -------------------

 def authenticate_login
  if session[:user].nil? #There's definitely no user logged in
   redirect_to :action => "index"
   flash[:notice] = "<font color=red>&nbsp;You are not logged in!</font>"
  else #there's a user logged in, but what type is he?
    @user = User.find(session[:user][:id]) # make sure user is in db, make sure they're not spoofing a session id
    if @user.nil?
     flash[:notice] = "<font color=red>&nbsp;You are not logged in!</font>"
     redirect_to :action => "index"
    else
     #session passed too!
    end
  end
end

  def login
    if request.post?
      if session[:user] = User.authenticate(params[:user][:username], Digest::SHA256.hexdigest(params[:user][:password]))
       flash[:notice] = "<font color=green>&nbsp;Login Successful!</font><br>"
       #redirect_to_stored
       session[:logged_in] = "y"
       flash[:notice] = "#{params[:user][:username]} logged in successfully!<br>"
       redirect_to :action => "list"
      else # authentication failed!
        flash[:notice] = "<font color=red>&nbsp;Login failed!</font><br>"
        redirect_to :action => "index"
      end
    end
  end

 def logout
  session[:user] = nil
  reset_session
  flash[:notice] = "<font color=green>&nbsp;You have been logged out! Have a nice day.</font>"
  redirect_to  :action => "index" 
 end

  def index
   if session[:user] and @user = User.find(session[:user][:id]) # user is already logged in
    redirect_to :action => "list"
   end 
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
   

  def list
    @posts = Post.find(:all, :order => "created_at DESC")
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
    @tags = Tag.find(:all, :conditions => ["post_id = ?", params[:id] ], :limit => 100)
    @comments = Comment.find(:all, :conditions => ["post_id = ?", params[:id] ], :limit => 500)
  end
  
  def edit_settings
   @settings = Setting.find(:all)
  end
 
  def edit_user
    @user = User.find(session[:user][:id], :limit => 1) 
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
      flash[:notice] << "The setting(#{name}) was updated!<br>"
     else
      flash[:notice] << "<font color=red>The setting(#{name}) failed updating!</font><br>"
     end
    else
     #flash[:notice] << "<font color=grey>The Setting(#{name}) has not changed.<br></font>"
    end
   end
   redirect_to :action => "edit_settings"
  end

  def update_user
   @user = User.find(params[:id])
   if @user.update_attributes(params[:user])
    flash[:notice] = 'User was successfully updated.'
    redirect_to :action => 'edit_user', :id => @user
   else
    flash[:notice] = get_errors_for(@user)  # get any errors
    render :action => 'edit_user'
   end
  end


  def destroy
    @comments = Comment.find(:all, :conditions => ["post_id = ?", params[:id] ])
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

  def tiny_mce_images
    #@images = Image.find(:all, :order => "created_at DESC")
    @images = Image.paginate :page => params[:page], :per_page => 3, :order => "created_at DESC"
    render :layout => false
  end
  
  def upload_tiny_mce_image
     require "RMagick"
     require "net/http"
     require "open-uri" 
      
     proceed = false
     if params[:file] != ""  && params[:url] == ""  #from their computer
      filename = clean_filename(params[:file].original_filename)
      if check_image_format(filename) #the filename isn't valid
       image = Magick::Image.from_blob(params[:file].read).first    # read in image binary
       proceed = true
      else
       flash[:notice] = "<div class=\"flash_failure\">#{params[:file].original_filename} upload failed! Please make sure that this is an image file, and that it ends in .png .jpg .jpeg .bmp or .gif </div> "     
      end 
     elsif params[:url] && !params[:file]  #from the web
      filename = clean_filename(File.basename(params[:url]))#.downcase # get the filename only
      if check_image_format(filename) #the filename is valid
       @url_file = open(params[:url]) # Open the image from net
       tmp_path = "#{RAILS_ROOT}/tmp/images" #location of the tmp folder
       FileUtils.mkdir_p(tmp_path) if !File.exist?(tmp_path) # create the tmp folder if it doesn't exist
       @file = open(tmp_path + "/" + filename, "wb") # open up the new file, binary style
       @file.write(@url_file.read) # copy the image
       if @file # temp file got copied successfully.
        # create files from tmp file
        # Dave: normally, I'd use the create_image or whatever method in this controller, but those are only written to handle file upload forms(it uses original_filename), not actual url 
        @file.close
        @file = open(tmp_path + "/" + filename, "rb") #reopen the temp file
        image = Magick::Image.from_blob(@file.read).first    # read in image binary
        # Remove temp image
        FileUtils.rm(tmp_path + "/" + filename)
        proceed = true
       end
      else # filename isn't valid!
       flash[:notice] = "<div class=\"flash_failure\">#{filename} upload failed! Please make sure that this is an image file, and that it ends in .png .jpg .jpeg .bmp or .gif </div> "     
      end
     elsif !params[:url].nil? && !params[:file].nil? #they accidentally did both
       flash[:notice] = "<div class=\"flash_failure\">Please select <b>one</b> #{item_object.name}, either from your computer or the web, <b>not both.</b></div> "     
        proceed = false
     else #random
       flash[:notice] = "<div class=\"flash_failure\">Error Code: 1 Occurred!<br>#{params[:file].inspect}</div> "     
       proceed = false
     end 
  
     if proceed # name okay, image object created
      image = create_normal_image(image, filename, @item) # make image, returns the new version of the image(if there's any effects, so the thumb and pinky have the same effects)
      create_thumbnail_image(image, filename, @item) # make thumbnail 
   
      @image = Image.new 
      @image.description = params[:image_description]
      site_url = "http://" + request.env["HTTP_HOST"] # the site url(absolute)
      @image.url = site_url + "/images/uploaded_images/normal/#{filename}"
      @image.thumb_url = site_url + "/images/uploaded_images/thumbnails/#{filename}"
      @image.user_id = session[:user][:id]
      
      if @image.save  #image was saved successfully
       flash[:notice] = "<div class=\"flash_success\">Image added successfully! Now you can select it from the <i>Select Image</i> Tab. </div><br>"     
      else # save failed
       flash[:notice] = get_errors_for(@image)
      end
    end
    #render :layout => false
    redirect_to :action => "tiny_mce_images"
 end
 
  
  def delete_image
     @image = Image.find(params[:id])
     if @image.destroy
       flash[:notice] = "<div class=\"flash_success\">Image deleted!</div><br>"     
     else # fail saved 
       flash[:notice] = "<div class=\"flash_failure\">Image could not be deleted!</div><br>"     
     end
     redirect_to :action => "tiny_mce_images"
  end
  
protected 
  # usually an error printer is used in the view(ie: error_messages_for), but I have several models sharing
  # one view, like the admin/edit.rhtml will handle posts, tags, and comments and I have seperate 
  # controllers that each form go to. Thus, having error_messages_for sitting in each view requires an
  # instance variable to be present in the view, which takes up extra memory.
  def get_errors_for(object) #format errors
   if object.errors
    @string = "<font color=red>There was a problem! Details:<br>"
     object.errors.each do |error, message|
     @string +=  "&nbsp;&nbsp;&nbsp;(#{error}) : #{message}<br>"
    end
    @string += "</font>"
    return @string
   end
  end
 
 def create_normal_image(image, filename, item)
  #use wb+ or wb to transfer as binary for binary sensitive files(pics, so, etc)
  path = "#{RAILS_ROOT}/public/images/uploaded_images/normal"
  FileUtils.mkdir_p(path) if !File.exist?(path)  

  # Resize Main Image
  if get_setting_bool("resize_item_images")
    width = get_setting("item_image_width").to_i
    height = get_setting("item_image_height").to_i
    #if params[:resize] == "cropped" # make a uniform image?
    image.crop_resized!( width, height )    
    #elsif params[:resize] == "proportional"
    # image.change_geometry!("#{width}x#{height}") { |cols, rows, img| img.resize!(cols, rows) }
    #elsif params[:resize] == "scale"
    # image.scale!( width, height )
    #elsif params[:resize] == "no" 
    #else
    #end
  end

  if params[:effect_monochrome] == "yes"
    image = image.quantize(256, Magick::GRAYColorspace)
  end

  if params[:effect_sepia] == "yes"
    image = image.quantize(256, Magick::GRAYColorspace)
    image = image.colorize(0.30, 0.30, 0.30, '#cc9933')
  end

  if params[:effect_watermark] == "yes"
   mark = Magick::Image.new(image.columns, image.rows)

   gc = Magick::Draw.new
   gc.gravity = Magick::CenterGravity
   gc.pointsize = 32
   gc.font_family = "Helvetica"
   gc.font_weight = Magick::BoldWeight
   gc.stroke = 'none'
   gc.annotate(mark, 0, 0, 0, 0, "Protected\r\nPhoto")

   mark = mark.shade(true, 310, 30)

   image.composite!(mark, Magick::CenterGravity, Magick::HardLightCompositeOp)
  end

  if params[:effect_polaroid] == "yes"
  image.border!(10, 10, "#f0f0ff")

  # Bend the image
  image.background_color = "none"

  amplitude = image.columns * 0.01        # vary according to taste
  wavelength = image.rows  * 2

  image.rotate!(90)
  image = image.wave(amplitude, wavelength)
  image.rotate!(-90)

  # Make the shadow
  shadow = image.flop
  shadow = shadow.colorize(1, 1, 1, "gray75")     # shadow color can vary to taste
  shadow.background_color = "white"       # was "none"
  shadow.border!(10, 10, "white")
  shadow = shadow.blur_image(0, 3)        # shadow blurriness can vary according to taste
  
  # Composite image over shadow. The y-axis adjustment can vary according to taste.
  image = shadow.composite(image, -amplitude/2, 5, Magick::OverCompositeOp)
  
  image.rotate!(-5)                       # vary according to taste
  #image.trim!
  end

  if params[:effect_rotate_90_cw] == "yes"
   image = image.rotate!(90)
  end

  if params[:effect_rotate_90_ccw] == "yes"
   image = image.rotate!(-90)
  end

  if params[:effect_rotate_180] == "yes"
   image = image.rotate!(180)
  end

  if params[:effect_gaussian_blur] == "yes"
   image = image.gaussian_blur(0.0, 3.0)
  end

  if params[:effect_negate] == "yes"
   image = image.negate
  end

  image.write("#{path}/#{filename}")      #save the image
  #params[:image][:width] = image.columns # set the original width into params 
  #params[:image][:height] = image.rows # set the original height into params
  return image
 end 

 def create_thumbnail_image(image, filename, item)
  #use wb+ or wb to transfer as binary for binary sensitive files(pics, so, etc)
  path = "#{RAILS_ROOT}/public/images/uploaded_images/thumbnails"
  FileUtils.mkdir_p(path) if !File.exist?(path)  
  #file.rewind # rewind the read pointer since create_image was called first
  #image = Magick::Image.from_blob(file.read).first    # read in image binary

  image.crop_resized!( get_setting("item_thumbnail_width").to_i, get_setting("item_thumbnail_height").to_i)
  image.write("#{path}/#{clean_filename(filename)}")  #save the image
 end 

 def clean_filename(filename) 
  @bad_chars = ['&', '\+', '%', '!', ' ', '/'] #string of bad characters
  for char in @bad_chars
   filename = filename.gsub(/#{char}/, "_") # replace the bad chars with good ones!
  end
  return filename 
 end

 def check_image_format(filename)
  extensions = /.png|.jpg|.jpeg|.gif|.bmp|.tiff|.PNG|.JPG|.JPEG|.GIF|.BMP|.TIFF$/ #define the accepted regexs
  return extensions.match(filename)   # return false or true if matched
 end 
 

end
