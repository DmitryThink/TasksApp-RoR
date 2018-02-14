Rails.application.routes.draw do
  resources :lists
  devise_for :users#, controllers: { sessions: 'users/sessions' }
  devise_scope :user do get '/users/sign_out' => 'devise/sessions#destroy' end
  resources :tasks
  resource :lists
  root 'lists#index'
  get 'lists/user/:userId/:listId' => 'tasks#listUserId'
  get 'lists/user/:userId' => 'lists#userId'
  get 'tasks/index/:listId' => 'tasks#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
