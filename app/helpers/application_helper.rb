# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  
  def image_thumbnail(image)
    return "<a href=\"#{image.thumb_url}\" target=\"_blank\"><img src=\"#{image.thumb_url}\" alt=\"#{image.description}\" title=\"#{image.description}\" border=0></a>"
  end
  
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
 
  def comment_avatar(comment)
    if comment.email 
      return "<img src='http://www.gravatar.com/avatar.php?gravatar_id=#{Digest::MD5.hexdigest(comment.email.downcase)}&s=50'>"
    else # don't use gravatar, check local avatars 
         return "<img src=\"/images/default_avatar.png\""
    end
  end  
end
