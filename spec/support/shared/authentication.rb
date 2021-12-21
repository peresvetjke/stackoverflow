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

shared_examples_for 'Authenticable' do |format|
  shared_examples "unauthorized" do
    it "returns unauthorized status" do
      subject
      expect(response).to have_http_status 401
    end
  end

  context 'being a guest' do
    shared_examples_for "js" do
      include_examples "unauthorized" 
    end

    shared_examples_for "json" do
      include_examples "unauthorized" 
    end

    shared_examples_for "html" do
      it "redirects to new_user_session path" do
        subject
        expect(response).to redirect_to new_user_session_path
      end
    end

    it "keeps object and count unchanged" do
      expect{subject}.not_to change(authenticable.class, :count)
      expect(authenticable.reload).to eq(authenticable) if authenticable.persisted?
    end

    it_behaves_like "#{format}"
  end
end