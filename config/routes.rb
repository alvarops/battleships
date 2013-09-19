Battleships::Application.routes.draw do

  get  '/ship/list',         to: 'ship#list'
  get  '/player/new',         to: 'player#new'
  post '/player/new',         to: 'player#new'
  get '/player/list',         to: 'player#list'

  get  '/player/:id',   to: 'player#stats'
  get  ':token/player/:id',   to: 'player#stats'
  get  ':token/mystats',   to: 'player#my_stats'

  get  ':token/game/new',     to: 'game#new'
  get  ':token/game/new/:secondPlayerId',     to: 'game#new'
  get  '/game/:id/stats',     to: 'game#stats'
  get  ':token/game/:id/stats',     to: 'game#stats'
  get  '/game/list',    to: 'game#list'
  get  ':token/game/list',    to: 'game#list'
  get  '/game/',    to: 'game#list'
  get  ':token/game/:id',     to: 'game#stats'
  get  ':token/game/:id/join',     to: 'game#join'
  get  ':token/game/:id/show',     to: 'game#show'

  get  ':token/game/:id/set', to: 'game#set'  #you can do ?ships=[<json array here>]
  post ':token/game/:id/set', to: 'game#set'

  get  ':token/game/:id/randomize', to: 'game#randomize'
  post ':token/game/:id/randomize', to: 'game#randomize'

  get  ':token/game/:id/shoot', to: 'game#shoot'


  get  '/error', to: 'error#show'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
