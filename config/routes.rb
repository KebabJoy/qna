Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  root to: 'questions#index'

  resources :badges, only: :index
  resources :files, only: :destroy
  resources :links, only: :destroy

  concern :votable do
    member do
      patch :vote_for
      patch :vote_against
      delete :cancel_vote
    end
  end

  resources :questions, concerns: %i[votable] do
    resources :comments, only: :create

    resources :answers, concerns: %i[votable], shallow: true do
      resources :comments, only: :create

      member do
        patch :make_best
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show update create destroy]
    end
  end

  mount ActionCable.server => '/cable'
end
