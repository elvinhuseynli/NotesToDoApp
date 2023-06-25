Rails.application.routes.draw do
  get 'friendships/index'
    devise_for :users
    
    devise_scope :user do
        authenticated :user do
            root 'posts#index', as: :authenticated_root
        end

        unauthenticated do
            root 'devise/sessions#new', as: :unauthenticated_root
        end
    end

    # root "posts#index"
    # config/routes.rb
    get '/friendships/send_request', to: 'friendships#send_request'

    get '/friendships/friends_list', to: 'friendships#friends_list'

    get 'friendships/invitations', to: 'friendships#invitations'

    patch 'friendships/:id/accept_request', to: 'friendships#accept',  as: 'friendships_accept_request'

    delete 'friendships/:id/reject_request', to: 'friendships#reject', as: 'friendships_reject_request'

    # config/routes.rb


    resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
