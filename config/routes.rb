Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  delete 'files/:id', to: 'files#destroy', as: 'files'

  resources :questions do
    resources :answers, shallow: true do
      member do
        patch :make_best
      end
    end
  end
end
