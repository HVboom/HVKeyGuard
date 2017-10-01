Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  devise_for :users
  resources :credentials, concerns: :paginatable do
    get :edit_document, on: :member
  end
  root to: 'credentials#index'
end
