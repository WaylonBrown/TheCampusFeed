TheCampusFeed::Application.routes.draw do



  get '/partials/:partialName' => 'partials#byName'

=begin
    scope '/api/v1', defaults: {format: :json} do
      shallow do
        get '/colleges/:id/image' => 'colleges#image'
        resources :colleges do
          get '/posts/byTag/:tagText' => 'posts#byTag'
          get '/posts/recent' => 'posts#recent'
          get '/posts/trending' => 'posts#trending'
          resource :posts do
            resources :comments do
              get 'votes/score' => 'votes#score'
              resources :votes do
              end
            end
          end
          get '/tags/trending' => 'tags#trending'
          resources :tags
        end
      end
    end
=end
    scope '/api/v1', defaults: {format: :json}, shallow_path: '/api/v1' do


      get '/minAndroidVersion' => 'versioner#android'
      get '/miniOSVersion' => 'versioner#ios'

      get '/comments/many' => 'comments#many'
      get '/posts/many' => 'posts#many'

      #resources :images, only: [:create, :index]
      resources :images, only: [:create, :show]
      resources :comments, only: [:show]
      resources :flags, only: [:show]
      resources :votes, only: [:show, :destroy]
      resources :users, only: [:show]


      get '/posts/search/:searchText' => 'posts#search'
      get '/posts/search/:searchText/count' => 'posts#searchCount'
      get '/posts/count' => 'posts#count'
      get '/posts/byTag/:tagText' => 'posts#byTag'
      get '/posts/recent' => 'posts#recent'
      get '/posts/trending' => 'posts#trending'
      get '/posts/hidden' => 'posts#hidden'
      get '/posts/flagged' => 'posts#flagged'
      get '/posts/flagged/count' => 'posts#flagged_count'
      resources :posts do
        get '/comments/search/:searchText' => 'comments#search'
        get '/comments/search/:searchText/count' => 'comments#searchCount'
        get '/comments/count' => 'comments#count'
        resources :comments, except: [:show] do
          get 'votes/score' => 'votes#score'
          resources :votes, only: [:create, :score, :destroy]
          resources :flags
        end
        get 'votes/score' => 'votes#score'
        resources :votes
        resources :flags
      end

      get '/tags/trending' => 'tags#trending'
      resources :tags



      #get '/colleges/listNearby' => 'colleges#listNearby'
      #get '/colleges/:id/within' => 'colleges#within'
      get '/colleges/:id/image' => 'colleges#image'
      get '/colleges/search/:searchText' => 'colleges#search'
      get '/colleges/search/:searchText/count' => 'colleges#searchCount'
      get '/colleges/count' => 'colleges#count'
      get '/colleges/trending' => 'colleges#trending'
      get '/colleges/listVersion' => 'colleges#listVersion'
      resources :colleges do

        get '/posts/byTag/:tagText' => 'posts#byTag'
        get '/posts/recent' => 'posts#recent'
        get '/posts/trending' => 'posts#trending'
        resources :posts do
          get '/comments/search/:searchText' => 'comments#search'
          get '/comments/search/:searchText/count' => 'comments#searchCount'
          get '/comments/count' => 'comments#count'
          resources :comments, except: [:show] do
            get 'votes/score' => 'votes#score'
            resources :votes, only: [:create, :score, :destroy]
            resources :flags
          end
          get 'votes/score' => 'votes#score'
          resources :votes
          resources :flags
        end

        get '/tags/trending' => 'tags#trending'
        resources :tags
      end


    end

#====================== PLANNED USER ROUTES BELOW ====================
=begin
      resources :users do
        #get '/colleges/listNearby' => 'colleges#listNearby'
        #get '/colleges/:id/within' => 'colleges#within'
        get '/colleges/:id/image' => 'colleges#image'
        resources :colleges, only: [:index] do

          get '/posts/byTag/:tagText' => 'posts#byTag'
          get '/posts/recent' => 'posts#recent'
          get '/posts/trending' => 'posts#trending'
          resources :posts do
            resources :comments, except: [:show] do
              get 'votes/score' => 'votes#score'
              resources :votes, only: [:create]
            end
            get 'votes/score' => 'votes#score'
            resources :votes
          end

          get '/tags/trending' => 'tags#trending'
          resources :tags
        end

        resources :comments, only: [:show]

        get '/posts/byTag/:tagText' => 'posts#byTag'
        get '/posts/recent' => 'posts#recent'
        get '/posts/trending' => 'posts#trending'
        resources :posts do
          resources :comments, except: [:show] do
            get 'votes/score' => 'votes#score'
            resources :votes, only: [:create]
          end
          get 'votes/score' => 'votes#score'
          resources :votes
        end

        get '/tags/trending' => 'tags#trending'
        resources :tags
      end
    end
=end
    root to: 'static_pages#landing'
    get '/college/:id' => 'static_pages#webapp_college'
    get '/tag/:text' => 'static_pages#webapp_tag'
    get '/post/:id' => 'posts#show'


    get '/admin' => 'static_pages#admin'
    get '/landing' => 'static_pages#landing'
    get '/mobile' => 'static_pages#index'
    get '/stats' => 'static_pages#stats'
    get '/webapp' => 'static_pages#webapp'
    get '/landing' => 'static_pages#landing'


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
