require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }


  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }
          .to change(question.answers, :count).by(1)
      end

      it 'redirects to question/show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }
          .to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let(:answer) { create(:answer, question: question, author: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #make_best' do
    context 'Author' do
      it 'changes the best answer' do
        login(user)

        patch :make_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to eq true
      end
    end

    context 'Different user' do
      it 'does not change the best answer' do
        user2 = create(:user)
        login(user2)

        answer = create(:answer, question: question, author: user)

        expect { patch :make_best, params: { id: answer }, format: :js }.to_not change(answer, :best)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, author: user) }

    context 'Author' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }
          .to change(question.answers, :count).by(-1)
      end
    end

    context 'Different user' do
      let(:user2) { create(:user) }

      it 'tries to delete the answer' do
        login(user2)

        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }
          .to change(question.answers, :count).by(0)
      end
    end
  end
end
