require "rails_helper"

describe "Questions API", type: :request do
  let(:headers)         {{ "CONTENT_TYPE" => "application/json",
                           "ACCEPT"       => "application/json" }}
  let!(:resource_owner) { create(:user) }
  let(:access_token)    { create(:access_token, resource_owner_id: resource_owner.id) }
  let(:method)          { "get" }

  describe "GET /api/v1/questions/:id" do
    let!(:question)         { create(:question, :with_link, :with_comments) }
    let(:question_response) { json["question"] }
    let(:path)              { "/api/v1/questions/#{question.id}" }

    before                  { attach_files_to(question, 2) }

    it_behaves_like "API Authorizable" do
      let(:api_method) { method }
      let(:api_path)   { path }
    end

    context "when authorized" do
      before do
        do_request("get", path, params: { access_token: access_token.token }, headers: headers) 
      end

      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all neccessary fields" do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
      
      it "returns all associated comments" do
        expect(question_response['comments'].map{ |c| c['id'] }.sort).to eq question.comments.ids.sort
      end

      it "returns neccessary fields for comments" do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(question_response['comments'].first[attr]).to eq question.comments.first.send(attr).as_json
        end
      end

      it "returns all associated links" do
        expect(question_response['links'].count).to eq question.links.count
      end

      it "returns neccessary fields for links" do
        %w[title url].each do |attr|
          expect(question_response['links'].first[attr]).to eq question.links.first.send(attr).as_json
        end
      end

      it "returns all associated attachments" do
        expect(question_response['attachments'].count).to eq question.files.count
      end

      it "returns neccessary fields for attachments" do
        expect(question_response['attachments']).to match_array(question.files.map{ |file| url_for(file) })
      end
    end
  end
end