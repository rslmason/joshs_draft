Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'main#index'
  get '/login', to: 'main#login'
  get '/admin', to: 'main#admin'

  get '/drafts', to: 'drafts#index'
  get '/drafts/new', to: 'drafts#new'
  post '/drafts/new', to: 'drafts#create'
  get '/drafts/:id', to: 'drafts#show'
  post '/drafts/:id', to: 'drafts#join'
  post '/drafts/:id/select', to: 'drafts#select'

  post '/drafts/:id/delete', to: 'drafts#delete'
  post '/users/:id/delete', to: 'users#delete'

  post '/user/login', to: 'users#login'
  get '/user/new', to: 'users#new'
  post '/user/new', to: 'users#create'
  post '/user/logout', to: 'users#logout'
end
