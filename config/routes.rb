Rails.application.routes.draw do
  resources :products

  get '/products-report/', to: 'products#report'
end
