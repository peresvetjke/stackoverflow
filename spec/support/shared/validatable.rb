shared_examples_for 'API Validatable' do
  let(:validatable_to_sym) { validatable.class.name.downcase.to_sym }
  let(:id) { validatable.id }
  let(:params) { { validatable_to_sym  => attributes_for(validatable_to_sym, :invalid), :access_token=> access_token.token } }

  context 'with invalid params' do
    before do 
      do_request(method, path, params: params, headers: headers)
    end

    it "returns unprocessable status" do
      expect(response.status).to eq 422
    end

    it "returns errors" do
      expect(json["errors"].empty?).to be_falsey
    end
  end
end