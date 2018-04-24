Rails.application.routes.draw do
  resources :products

  get '/report/', to: 'products#report'
end
