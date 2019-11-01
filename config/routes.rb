# frozen_string_literal: true

Rails.application.routes.draw do
  resources :matches, only: [:create, :new] do
    resources :players, only: [:show] do
      resources :games, only: [:create, :edit, :update, :destroy]
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'matches#new'
end
