require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'authorized' do
      before { login(user) }

      it 'saves a new subscription to the database' do
        expect { post :create, params: { question_id: question } }.to change(question.subscriptions, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: { question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not authorized' do
      it 'does not save a new subscription to the database' do
        expect { post :create, params: { question_id: question } }.to_not change(question.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:subscription) { create(:subscription, user: user) }

    context 'user already subscribed' do
      it 'deletes the subscription' do
        expect { delete :destroy, params: { id: subscription } }.to change(user.subscriptions, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: subscription }
        expect(response).to redirect_to question_path(subscription.question)
      end
    end

    context 'user not subscribed' do
      let(:subscription) { create(:subscription) }

      it 'does not delete subscription' do
        expect { delete :destroy, params: { id: subscription } }.to_not change(user.subscriptions, :count)
      end
    end
  end
end
