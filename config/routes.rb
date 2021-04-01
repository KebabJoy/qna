Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :badges, only: :index
  resources :files, only: :destroy
  resources :links, only: :destroy

  resources :questions do
    resources :answers, shallow: true do
      member do
        patch :make_best
      end
    end
  end

end
