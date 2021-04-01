require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  describe 'GET #index' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }
    let(:badges) { create_list(:badge, 33, question: question, user: user) }

    before do
      login user
      get :index
    end

    it "populates an array of all user's badges" do
      expect(assigns(:badges)).to match_array(badges)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
