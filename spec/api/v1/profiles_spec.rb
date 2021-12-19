require "rails_helper"

describe "Profiles API", type: :request do
  let(:headers) { { "CONTENT_TYPE"  => "application/json",
                    "ACCEPT"        => "application/json" } }
  let(:me)           { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe "GET /api/v1/profiles/me" do
    let(:path) { "/api/v1/profiles/me" }
    
    context "when unauthorized" do
      it "returns 401 status if there is no access_token" do
        do_request("get", path, headers: headers)
        expect(response.status).to eq 401
      end

      it "returns 401 status if there is invalid" do
        do_request("get", path, params: { access_token: "1234" }, headers: headers)
        expect(response.status).to eq 401
      end
    end

    context "when authorized" do
      before { do_request("get", path, params: { access_token: access_token.token }, headers: headers) }

      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all neccessary fields" do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json["user"][attr]).to eq me.send(attr).as_json
        end
      end

      it "does not return private fields" do
        %w[password encrypted_password].each do |attr|
          expect(json["user"]).to_not have_key(attr)
        end
      end
    end    
  end

  describe "GET /api/v1/profiles" do

  end
end