shared_examples_for 'API Validatable' do
  let(:validatable_to_sym) { validatable.class.name.downcase.to_sym }
  let(:params) { { validatable_to_sym  => attributes_for(validatable_to_sym, :invalid), :access_token=> access_token.token } }

  context 'with invalid params' do
    before do 
      do_request(method, path, params: params, headers: headers)
    end

    include_examples "it_returns_status", 422

    it "returns errors" do
      expect(json["errors"].empty?).to be_falsey
    end
  end
end