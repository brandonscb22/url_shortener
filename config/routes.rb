Rails.application.routes.draw do
  resources :links
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/:short_code', to: 'links#short_code'
end
