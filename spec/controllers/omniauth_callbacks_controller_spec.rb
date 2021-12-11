require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController, :type => :controller do
  let (:user) { create(:user)}
  let (:oauth_data_with_email)    { OmniAuth::AuthHash.new({:provider => 'github', :uid => '12345677', :info => { :email => user.email } }) }
  let (:oauth_data_without_email) { OmniAuth::AuthHash.new({:provider => 'github', :uid => '12345677' }) }

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  context 'user exists' do
    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_without_email)
      allow(User).to receive(:find_for_oauth).and_call_original
      allow(User).to receive(:find_for_oauth).and_return(user)
      user.confirmed_at = Time.now
      get :github
    end

    it 'login user' do
      expect(subject.current_user).to be_truthy
    end

    it 'redirects to root path' do
      expect(response).to redirect_to root_path
    end

    it 'does not save uid and provider in session' do
      expect(session["oauth.uid"]).to be_nil
      expect(session["oauth.provider"]).to be_nil
    end
  end

  context 'user does not exist' do
    context 'with email provided' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_with_email)
        allow(User).to receive(:find_for_oauth).and_call_original
        allow(User).to receive(:find_for_oauth).and_return(user)
        user.confirmed_at = Time.now
        get :github
      end

      it 'login user' do      
        expect(subject.current_user).to be_truthy
      end
      
      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not save uid and provider in session' do
        expect(session["oauth.uid"]).to be_nil
        expect(session["oauth.provider"]).to be_nil
      end
    end

    context 'without provided email' do
      before do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data_without_email)
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'saves uid and provider in session' do
        expect(session["oauth.uid"]).to eq oauth_data_without_email.uid
        expect(session["oauth.provider"]).to eq oauth_data_without_email.provider
      end

      it 'redirects to new_user_registration_url' do
        expect(response).to redirect_to new_user_registration_path
      end
    end
  end
end
