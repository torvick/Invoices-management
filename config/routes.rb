# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'api/v1/sessions', registrations: 'api/v1/registrations'}

  namespace :api do
    namespace :v1 do
      resources :documents
      resources :invoices do
        get :qr
        collection{
          post :import
        }
      end
      resources :emitters do
        resources :invoices, only: [:index, :show]
      end
      # resources :receiver do
      #   resources :invoices, only: [:index, :show]
      # end
    end
  end
end
