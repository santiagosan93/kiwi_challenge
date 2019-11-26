Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'devices#index'
  post '/upload', to: 'devices#proces_csv', as: 'upload'

  # This route was made for testing purposes
  # get '/new_csv', to: 'devices#new_csv'
end
