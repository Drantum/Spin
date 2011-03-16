module ApplicationHelper
  
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
 
 def title(page_title)
  content_for(:title) { page_title }
 end

 def coderay(text)
   text.gsub!(/\<code(?: lang="(.+?)")?\>(.+?)\<\/code\>/m) do
     code = CodeRay.scan($2, $1).div(:css => :class)
     "<notextile>#{code}</notextile>"
   end
   return text.html_safe
 end

 def avatar_url(comment)
   if File.exists?(RAILS_ROOT + "/public/themes/#{@style}/images/avatar.png")
	 	default_url = "#{root_url}themes/#{@style}/images/avatar.png"
	 else
   	default_url = "#{root_url}images/avatar.png"
	 end
   	gravatar_id = Digest::MD5.hexdigest(comment.email.downcase)
  	"http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
 end
end
