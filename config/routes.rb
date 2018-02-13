Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_scope :user do get '/users/sign_out' => 'devise/sessions#destroy' end
  resources :tasks
  root 'tasks#index'
  get 'tasks/user/:userId' => 'tasks#listUserId'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
