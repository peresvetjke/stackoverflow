shared_examples_for 'API Authenticable' do
  context 'unauthenticated' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, path, params: {access_token: '1234'}, headers: headers)
      expect(response.status).to eq 401
    end
  end
end