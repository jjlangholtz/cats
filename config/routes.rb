Rails.application.routes.draw do
  resources :cats, only: [:show, :index, :create, :update, :destroy]
end
