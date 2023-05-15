# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, param: :username
      post '/auth/login', to: 'authentication#login'
      resources :communities, param: :name do
        resources :posts do
          resources :comments
        end
      end
    end
  end
end
