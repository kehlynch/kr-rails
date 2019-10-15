# frozen_string_literal: true

Rails.application.routes.draw do
  resources :games, except: [:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'games#new'
end
