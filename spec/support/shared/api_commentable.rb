shared_examples_for 'API Commentable' do
  let!(:comments) { create_list(:comment, 3, commentable: commentable) }
  let(:comment) { comments.first }

  before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

  context 'comments' do
    it 'returns list of comments' do
      expect(comment_response['comments'].size).to eq 3
    end

    it 'returns comment fields' do
      %w[id body created_at updated_at].each do |attr|
        expect(comment_response['comments'].first[attr]).to eq comment.send(attr).as_json
      end
    end
  end
end
