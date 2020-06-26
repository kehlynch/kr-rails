# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/channels'

  get '/', to: 'players#show', as: :home

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'logout', to: 'sessions#destroy'

  post 'join/:match_id', to: 'players#join_match', as: :join_match
  post 'play/:match_id', to: 'players#play_match', as: :play_match

  get 'play', to: 'games#play', as: :play
  get 'scores', to: 'matches#scores', as: :scores

  resources :matches, only: [:create, :new, :destroy, :update] do
    resources :games, only: [:create, :edit, :update] do
      post :next, on: :member
      post :reset, on: :member
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'matches#index'
end
