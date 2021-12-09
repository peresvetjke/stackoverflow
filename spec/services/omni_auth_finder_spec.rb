require 'rails_helper'

RSpec.describe OmniAuthFinder do

  let!(:other_user) { create(:user) }
  let!(:user)       { create(:user) }
  let(:auth)        { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
  subject           { OmniAuthFinder.new(auth) }

  context "new authentification and user" do
    it 'creates user' do
      expect{ subject.call }.to change(User, :count).by(1)
    end

    it 'creates authentification' do
      expect{ subject.call }.to change(Authentification, :count).by(1)
    end

    it 'returns user' do
      expect(subject.call).to eq(user)
    end
  end

  context "authentification and user exist" do
    let!(:authentification)  { create(:authentification, provider: 'facebook', uid: '123456', user: user) }

    it 'returns user' do
      expect(subject.call).to eq(user)
    end

    it "doesn't create new authentifications" do
      expect { subject.call }.not_to change(Authentification, :count)
    end

    it "doesn't create new user" do
      expect { subject.call }.not_to change(User, :count)
    end
  end

    
    
end