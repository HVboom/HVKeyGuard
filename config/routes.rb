Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  resources :credentials do
    get :edit_document, on: :member
  end
  root to: 'credentials#index'
end
