Postfeed::Application.routes.draw do


  resources :users

    scope '/api/v1', defaults: {format: :json} do

      #get '/colleges/listNearby' => 'colleges#listNearby'
      #get '/colleges/:id/within' => 'colleges#within'
      resources :colleges, only: [:index] do
        get '/posts/byTag/:tagText' => 'posts#byTag'
        get '/posts/recent' => 'posts#recent'
        get '/posts/trending' => 'posts#trending'
        resources :posts do
          resources :comments, except: [:show] do
            get 'votes/score' => 'votes#score'
            resources :votes
          end
          get 'votes/score' => 'votes#score'
          resources :votes
        end
      end



      resources :comments, only: [:show]

      get '/posts/byTag/:tagText' => 'posts#byTag'
      get '/posts/recent' => 'posts#recent'
      get '/posts/trending' => 'posts#trending'
      resources :posts do
        resources :comments, except: [:show] do
          get 'votes/score' => 'votes#score'
          resources :votes
        end
        get 'votes/score' => 'votes#score'
        resources :votes
      end


      get '/tags/trending' => 'tags#trending'
      resources :tags
    end

    root to: 'static_pages#index'

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
