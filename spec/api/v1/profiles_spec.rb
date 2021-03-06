require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_tYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it "doesn't return private fields" do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let!(:profiles) { create_list(:user, 3) }
    let(:me) { profiles.last }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all profiles' do
        expect(json.size).to eq 2
      end

      it 'returns public fields' do
        json.each do |profile_response|
          %w[id admin email created_at updated_at].each do |attr|
            expect(profile_response).to have_key(attr)
          end
        end
      end

      it "doesn't return authenticated user" do
        json.each do |profile_response|
          expect(profile_response['id']).to_not eq me.id
        end
      end

      it "doesn't return private fields" do
        json.each do |profile_response|
          %w[password encrypted_password].each do |attr|
            expect(profile_response).to_not have_key(attr)
          end
        end
      end
    end
  end
end
