ActionController::Routing::Routes.draw do |map|  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  
  map.connect "events/past", :controller => "events", :action => "past"
  map.connect "events/past.:format", :controller => "events", :action => "past"

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.admin "admin", :namespace => "admin", :controller => "home"
  map.password_reset "users/:username/reset/:reset_hash", :controller => "users", :action => "password_reset"
  map.login "login", :controller => "users", :action => "login"
  map.logout "logout", :controller => "users", :action => "logout"
  map.article_diff "admin/articles/:id/compare/:rev_a/:rev_b", :namespace => "admin", :controller => "articles", :action => "compare"
  map.change_revision "admin/articles/:id/change_revision/:revision", :namespace => "admin", :controller => "articles", :action => "change_revision"
  map.categories "articles/categories/:id", :controller => "articles", :action => "categories"
  map.profile "profiles/:username", :controller => "users", :action => "show"
  
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }
  
  map.resources :news, :singular => :news_article
  map.resources :articles
  map.resources :events

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  map.namespace :admin do |admin|
    admin.resources :users
    admin.resources :news, :singular => :news_article
    admin.resources :articles
    admin.resources :events
    admin.resources :galleries
    admin.resources :categories
  end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect "profile", :controller => "users", :action => "profile"
  map.connect "sitemap.xml", :controller => "sitemap", :action => "index"
  map.connect "search/opensearch.xml", :controller => "search", :action => "opensearch"
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
