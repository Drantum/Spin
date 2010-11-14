class Post < ActiveRecord::Base
 has_many :comments 
 has_many :tags
 belongs_to :user

 validates_presence_of :title, :message => "No title specified!"
 validates_presence_of :content, :message => "No content specified!"
 validates_uniqueness_of :title, :message => "This title already exists!"
 validates_length_of :title, :maximum => 50, :message => "Please specify a title 50 characters or less."

 before_destroy :delete_comments
 before_destroy :delete_tags

  def to_param # make custom parameter generator for seo urls, to use: pass actual object(not id) into id ie: :id => object
    # this is also backwards compatible with regular integer id lookups, since .to_i gets only contiguous numbers, ie: "4-some-string-here".to_i # => 4    
    "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}" 
  end

 def delete_comments
  for comment in self.comments
   comment.destroy
  end
 end

 def delete_tags
  for tag in self.tags
   tag.destroy
  end
 end

end
