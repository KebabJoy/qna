require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:link) { create(:link, linkable: question) }

    context 'Author' do
      before { login(user) }

      it 'deletes link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
      end
    end

    context 'Different user' do
      it 'tries to delete question' do
        user2 = create(:user)
        login(user2)

        expect { delete :destroy, params: { id: link } }.to change(Link, :count).by(0)
      end
    end
  end
end
