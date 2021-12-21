require "rails_helper"

describe "Profiles API", type: :request do
  let(:headers)         {{ "ACCEPT" => "application/json" }}
  let!(:me)             { create(:user) }
  let(:me_response)     { json["user"] }
  let(:users_response)  { json["users"] }
  let(:access_token)    { create(:access_token, resource_owner_id: me.id) }
  let(:method)          { "get" }

  describe "GET /api/v1/profiles/me" do
    let(:path)         { "/api/v1/profiles/me" }
    
    it_behaves_like "API Authenticable"

    context "when authenticated" do
      before { do_request("get", path, params: { access_token: access_token.token }, headers: headers) }

      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all neccessary fields" do
        %w[id email admin created_at updated_at].each do |attr|
          expect(me_response[attr]).to eq me.send(attr).as_json
        end
      end

      it "does not return private fields" do
        %w[password encrypted_password].each do |attr|
          expect(me_response).to_not have_key(attr)
        end
      end
    end
  end

  describe "GET /api/v1/profiles" do
    let(:path)    { "/api/v1/profiles" }
    let!(:users)  { create_list(:user, 4) }

    it_behaves_like "API Authenticable"

    context "when authenticated" do
      before { do_request("get", path, params: { access_token: access_token.token }, headers: headers) }

      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all the records except the authenticated one" do
        expect(users_response.count).to eq users.count
      end

      it "returns all neccessary fields" do
        %w[id email admin created_at updated_at].each do |attr|
          expect(users_response.last[attr]).to eq User.last.send(attr).as_json
        end
      end

      it "does not return private fields" do
        %w[password encrypted_password].each do |attr|
          expect(users_response.last).to_not have_key(attr)
        end
      end
    end
  end
end