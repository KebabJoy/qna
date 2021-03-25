require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:file) { question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }

  describe 'DELETE #destroy' do
    context 'author of the file' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.
          to change(question.files, :count).by(-1)
      end
    end

    context 'different user' do
      before { login(user2) }

      it "doesn't delete the answer" do
        expect do
          delete :destroy, params: { id: question.files.first }, format: :js
        end.to_not change(question.files, :count)
      end

      it 'returns forbidden status' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to have_http_status :forbidden
      end
    end
  end
end
