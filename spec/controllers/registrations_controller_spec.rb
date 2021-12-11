require "rails_helper"

RSpec.describe Users::RegistrationsController, :type => :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "POST create" do
    context 'default registration' do
      let(:user) { build(:user) }
      subject { post :create, params: { user: { email: user.email, password: "xxxxxxxx"} } }
      it "creates new user" do
        expect { subject }.to change(User, :count).by(1)
      end

      it "redirects to root path" do
        subject
        expect(response).to redirect_to root_path
      end
    end
    
    context 'omniauth provider info' do
      before { request.session = { "oauth.provider" => "github", "oauth.uid" => "12345" } }

      context 'user exists' do
        let!(:user) { create(:user, confirmed_at: nil) }
        subject do 
          post :create, params: { user: { email: user.email } } 
        end

        it "does not create new user" do
          expect { subject }.not_to change(User, :count)
        end

        it "creates new authentication" do
          expect { subject }.to change(Authentication, :count).by(1)
        end

        it "clears up cookies" do
          subject
          expect(session["oauth.uid"]).to be_nil
          expect(session["oauth.provider"]).to be_nil
        end

        context 'user has not confirmed email yet' do
          it "does not login user" do
            subject
            expect(controller.current_user).to be_falsey
          end

          it 'redirects to root path' do
            subject
            expect(response).to redirect_to root_path
          end
        end

        context 'user has already confirmed email' do
          before { user.update(confirmed_at: Time.now) }

          it "login user" do
            subject
            expect(controller.current_user).to be_truthy
          end

          it 'redirects to root path' do
            subject
            expect(response).to redirect_to root_path
          end
        end
      end

      context 'user does not exist' do
        subject do 
          post :create, params: { user: {email: 'new_user@example.com'} }
        end

        it "creates new user" do
          expect { subject }.to change(User, :count).by(1)
        end

        it "creates new authentication" do
          expect { subject }.to change(Authentication, :count).by(1)
        end

        it "does not login user" do
          subject
          expect(controller.current_user).to be_falsy
        end

        it 'redirects to root path' do
          subject
          expect(response).to redirect_to root_path
        end

        it "clears up cookies" do
          subject
          expect(session["oauth.uid"]).to be_nil
          expect(session["oauth.provider"]).to be_nil
        end
      end
    end
  end
end