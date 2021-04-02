Rails.application.routes.draw do
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
    resources :answers, concerns: %i[votable], shallow: true do
      member do
        patch :make_best
      end
    end
  end

end
