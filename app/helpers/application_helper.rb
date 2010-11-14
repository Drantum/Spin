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
 
end
