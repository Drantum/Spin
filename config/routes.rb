ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "browse"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect '/tag/:tag' , :controller => "browse", :action => "tag"

  map.connect '/:year/:month/:day',
               :controller => 'browse',
               :action     => 'archive',
               :month => nil, :day => nil,
               :requirements => {:year => /\d{4}/, :month => /\d{1,2}/,:day => /\d{1,2}/ }

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'

#Dave: for future use: sort articles by date
# map.connect 'articles/:year/:month/:day',
#             :controller => 'articles',
#             :action     => 'find_by_date',
#             :year       => /\d{4}/,
#             :month      => /\d{1,2}/,
#             :day        => /\d{1,2}/
#
# # Using the route above, the url below maps to:
# # params = {:year => '2005', :month => '11', :day => '06'}
# # http://localhost:3000/articles/2005/11/06


  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'

end
