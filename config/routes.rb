# frozen_string_literal: true

Rails.application.routes.draw do
  get 'game/show'
  post 'game/play'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'game#show'
end
