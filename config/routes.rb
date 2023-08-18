Rails.application.routes.draw do
  root "posts#index"
  resources :posts
  get "ballon", to: "posts#balloon", as: :balloon
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
