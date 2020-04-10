# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/channels'

  resources :matches, only: [:create, :new, :index, :destroy] do
    resources :players, only: [:show, :new, :create] do
      resources :games, only: [:create, :edit, :update] do
        post :next, on: :member
        post :reset, on: :member
      end
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'matches#index'
end
