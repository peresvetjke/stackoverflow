require "rails_helper"

describe "Answers API", type: :request do
  let(:headers)         {{ "CONTENT_TYPE" => "application/json",
                           "ACCEPT"       => "application/json" }}
  let!(:resource_owner) { create(:user) }
  let(:access_token)    { create(:access_token, resource_owner_id: resource_owner.id) }
  let(:method)          { "get" }

  describe "GET /api/v1/questions/:question_id/answers" do
    let(:question)          { create(:question) }
    let!(:answers)          { create_list(:answer, 5, question: question) }
    let(:answers_response)  { json["answers"] }
    let(:path)              { "/api/v1/questions/#{question.id}/answers" }

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

      it "returns all the answers by selected question" do
        expect(answers_response.map{ |a| a['id'] }.sort).to eq question.answers.ids.sort
      end

      it "returns all neccessary fields" do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(answers_response.first[attr]).to eq question.answers.first.send(attr).as_json
        end
      end
    end
  end
end