require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_tYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains author object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }
    let(:question_response) { json['question'] }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'API Commentable' do
        let(:commentable) { question }
        let(:comment_response) { question_response }
      end

      it_behaves_like 'API Linkable' do
        let(:linkable) { question }
        let(:link_response) { question_response }
      end

      it_behaves_like 'API Attachable' do
        let(:attachable) { question }
        let(:file_response) { question_response }
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:access_token) { create(:access_token) }
    let(:method) { :post }
    let(:api_path) { '/api/v1/questions' }

    let(:valid_attributes) { { access_token: access_token.token, question: attributes_for(:question) } }
    let(:invalid_attributes) do
      { access_token: access_token.token, question: attributes_for(:question, :invalid) }
    end

    before { do_request(method, api_path, params: valid_attributes, headers: headers) }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect do
            do_request(method, api_path, params: valid_attributes, headers: headers)
          end.to change(Question, :count).by(1)
        end

        it 'return status 200' do
          do_request(method, api_path, params: valid_attributes, headers: headers)
          expect(response).to be_successful
        end

        it 'returns question fields' do
          do_request(method, api_path, params: valid_attributes, headers: headers)

          %w[id title body created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
        end
      end

      context 'with invalid attributes' do
        it "doesn't save new question to the database" do
          expect do
            do_request(method, api_path, params: invalid_attributes, headers: headers)
          end.to_not change(Question, :count)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:access_token) { create(:access_token) }
    let(:question) { create(:question, author_id: access_token.resource_owner_id) }

    let(:valid_attributes) { { access_token: access_token.token, question: { title: 'updated' } } }
    let(:invalid_attributes) { { access_token: access_token.token, question: { title: nil } } }

    let(:method) { :patch }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'author' do
        context 'with valid attributes' do
          it 'edits the question' do
            do_request(method, api_path, params: valid_attributes, headers: headers)
            question.reload
            expect(question.title).to eq valid_attributes[:question][:title]
          end

          it 'returns status 200' do
            do_request(method, api_path, params: valid_attributes, headers: headers)
            question.reload
            expect(response).to be_successful
          end
        end

        context 'with invalid attributes' do
          it "doesn't edits the question" do
            do_request(method, api_path, params: invalid_attributes, headers: headers)
            question.reload
            expect(question.title).to_not eq invalid_attributes[:question][:title]
          end

          it 'returns status 412' do
            do_request(method, api_path, params: invalid_attributes, headers: headers)
            question.reload
            expect(response).to have_http_status(:precondition_failed)
          end
        end
      end

      context 'not author' do
        let(:question) { create(:question) }

        it "doesn't edits the question" do
          do_request(method, api_path, params: valid_attributes, headers: headers)
          question.reload
          expect(question.title).to_not eq valid_attributes[:question][:title]
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:access_token) { create(:access_token) }
    let(:question) { create(:question, author_id: access_token.resource_owner_id) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/questions/#{question.id}" }


    it_behaves_like 'API Authorizable'

    context 'authorized' do
      context 'author' do
        it 'deletes the question' do
          expect do
            do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
          end.to change(question.author.authored_questions, :count).by(-1)
        end

        it 'returns status 200' do
          do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
          expect(response).to be_successful
        end
      end

      context 'not author' do
        let!(:question) { create(:question) }

        it "doesn't deletes the question" do
          expect do
            do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
          end.to_not change(question.author.authored_questions, :count)
        end

        it 'returns status 403' do
          do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end


end
