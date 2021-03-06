Jammer::Application.routes.draw do

  get "investments/list"
  resources :users, only: [:index, :show] do
    get :export, :on => :collection
    get :al_chart_data
    get :borrowing_chart_data
    get :lending_chart_data
  end

  resources :loans, only: [:index, :show]
  resources :investments, only: [:index]

  root 'users#root_redirect'

  get 'stats' => 'meta#stats'
  get 'faq' => 'meta#faq'
  get 'todo' => 'meta#todo'
  get 'stats/btc_stats' => 'meta#btc_stats'
  get 'stats/loan_stats' => 'meta#loan_stats'
  get 'stats/user_stats' => 'meta#user_stats'
  get 'stats/borrower_stats' => 'meta#borrower_stats'

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
