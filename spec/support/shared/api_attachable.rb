shared_examples_for 'API Attachable' do
  describe 'files' do
    it 'returns file urls' do
      attachable.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb')

      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)

      expect(file_response['files'].size).to eq attachable.send('files').size
    end
  end
end
