Rails.application.routes.draw do
  resources :lists
  devise_for :users
  resources :tasks
  resource :lists
  root 'lists#index'
  get 'lists/user/:userId/:listId' => 'tasks#publicIndex'
  get 'lists/user/:userId' => 'lists#publicIndex'
  get 'tasks/index/:listId' => 'tasks#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
