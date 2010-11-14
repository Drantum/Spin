Blog::Application.routes.draw do
  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.

  # map.connect '', :controller => "browse"
  root :to => "browse#index"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # map.connect ':controller/service.wsdl', :action => 'wsdl'
  match ':controller/service.wsdl' => '#wsdl'

  # map.connect '/tag/:tag' , :controller => "browse", :action => "tag"
  match '/tag/:tag' => 'browse#tag'

  # map.connect '/:year/:month/:day',
  #             :controller => 'browse',
  #             :action     => 'archive',
  #             :month => nil, :day => nil,
  #             :requirements => {:year => /\d{4}/, :month => /\d{1,2}/,:day => /\d{1,2}/ }
  match '/:year/:month/' => 'browse#archive', :constraints => {:year => /\d{4}/, :month => /\d{1,2}/ }

  # Install the default route as the lowest priority.
  # map.connect ':controller/:action/:id.:format'
  match ':controller(/:action(/:id(.:format)))'
  # map.connect ':controller/:action/:id'
  match ':controller(/:action(/:id))'

  # map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  match '/simple_captcha/:action' => 'simple_captcha', :as => :simple_captcha
end
