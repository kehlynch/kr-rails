# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/channels'

  namespace :api do
    resources :sessions, only: [:create] do
      get :retrieve, on: :collection
      delete :destroy, on: :collection
    end

    resources :matches, only: [:create] do
      get :current, on: :collection
      get :list_open, on: :collection
      put :goto_last_game, on: :member
      put :set, on: :member
    end

    resources :games, except: [:update] do
      get :current, on: :collection
      patch :update_current, on: :collection
      get :test, on: :collection
    end
    resources :game_players, only: [:update]
    # resources :games, only: [:show, :index, :create, :update, :destroy] do
    # end
    # get '/pickable', to: 'games#pickable'
  end

  # get 'login', to: 'sessions#new', as: :login
  # post 'login', to: 'sessions#create'
  # post 'logout', to: 'sessions#destroy', as: :logout

  # get 'about', to: 'about#about', as: :about

  # post 'join/:match_id', to: 'players#join_match', as: :join_match
  # post 'play/:match_id', to: 'players#play_match', as: :play_match

  # # get 'play', to: 'games#play', as: :play
  # get 'scores', to: 'matches#scores', as: :scores

  # resources :players, only: :index

  # resources :matches, only: [:create, :new, :destroy, :update] do
  #   resources :games, only: [:create, :update] do
  #     post :next, on: :member
  #     post :reset, on: :member
  #   end
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepage#index', as: :home
  get 'play', to: 'homepage#index', as: :play
  get '/*path' => 'homepage#index'
end
