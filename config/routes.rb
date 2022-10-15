# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'api/v1/sessions', registrations: 'api/v1/registrations'}

  namespace :api do
    namespace :v1 do

    end
  end
end
