shared_examples_for 'API Authorizable' do
  let(:authorizable_to_sym) { authorizable.class.name.downcase.to_sym }
  let(:params) { { authorizable_to_sym  => attributes_for(authorizable_to_sym), :access_token => create(:access_token, resource_owner_id: user.id).token } }
  
  before { do_request(method, path,  params: params, headers: headers) }

  context 'not an author of record' do
    let(:user) { create(:user) }

    it "returns status 'forbidden'" do
      expect(response.status).to eq 403
    end
  end

  context 'an admin' do
    let(:user) { create(:user, admin: true) }

    it "returns successful status" do
      expect(response).to be_successful
    end
  end
end