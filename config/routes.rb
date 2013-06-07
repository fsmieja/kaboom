Kaboom::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => 'projects#index'

  match 'tags/delete_all'       => 'tags#delete_all', as: :delete_all_tags, via: :put 

  resources :projects, :notes, :tags

  match 'project/:id/notes'     => 'notes#index', as: :project_notes, via: :get 
  match 'note/:id/tags'         => 'notes#tags', as: :note_tags, via: :get 
  match 'note/:id/add_tag'      => 'notes#tag', as: :tag_note, via: :put 
  match 'note/:id/toggle_tag'   => 'notes#toggle_tag', as: :toggle_tag_note, via: :put 
  match 'note/:id/create_tag'   => 'notes#create_tag', as: :create_tag_note 
  match 'note/:id/remove_tag'   => 'notes#remove_tag', as: :remove_tag_from_note, via: :post 
  match 'note/:id/add_note'     => 'notes#add_note', as: :add_note_to_note, via: :put 
  match 'note/set_position'     => 'notes#set_position', as: :note_position, via: :put 
  match 'project/:id/note/new'  => 'notes#new', as: :new_project_note, via: :get 
  match 'project/:id/divide'    => 'notes#divide', as: :divide_notes, via: :get 
  
  match 'project/:id/add_tag'   => 'projects#tag', as: :tag_project, via: :put   
  
  match 'project/:id/tags'      => 'tags#index', as: :project_tags, via: :get 
  match 'tag/:id/mindmap'       => 'tags#mindmap', as: :mindmap, via: :get 
   
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
