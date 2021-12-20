require "rails_helper"

describe "Questions API", type: :request do
  let(:headers)           { { "ACCEPT"       => "application/json" } }
  let!(:resource_owner)   { create(:user) }
  let(:access_token)      { create(:access_token, resource_owner_id: resource_owner.id) }
  let!(:question)         { create(:question, author: resource_owner) }
  let(:question_response) { json["question"] }

  %i[validatable authorizable commentable linkable attachable].each do |able|
    let(able) { question }
  end

  describe "GET /api/v1/questions" do
    let(:method)              { "get" }
    let!(:questions)          { create_list(:question, 5) }
    let(:questions_response)  { json["questions"] }
    let(:path)                { "/api/v1/questions" }

    it_behaves_like "API Authenticable"

    context "when authenticated" do
      before { do_request("get", path, params: { access_token: access_token.token }, headers: headers) }

      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all neccessary fields" do
        %w[id title body created_at updated_at].each do |attr|
          expect(questions_response.last[attr]).to eq questions.last.send(attr).as_json
        end
      end
    end
  end

  describe "GET /api/v1/questions/:id" do
    let(:method)    { "get" }
    let!(:question) { create(:question, :with_link, :with_comments) }
    let(:path)      { "/api/v1/questions/#{question.id}" }
    before          { attach_files_to(question, 2) }

    it_behaves_like "API Authenticable"

    context "when authenticated" do
      before { do_request("get", path, params: { access_token: access_token.token }, headers: headers) }

      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all neccessary fields" do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it_behaves_like "API Commentable"      
      it_behaves_like "API Linkable"      
      it_behaves_like "API Attachable"
    end
  end

  describe "POST /api/v1/questions" do
    let(:method)    { "post" }
    let(:path)      { "/api/v1/questions" }

    it_behaves_like "API Authenticable"
    it_behaves_like "API Validatable"

    context "when authenticated" do
      context 'with valid params' do
        before { do_request(method, path, params: { question: attributes_for(:question), access_token: access_token.token }, headers: headers) }

        it "return status 'created'" do
          expect(response.status).to eq 201
        end

        it "returns all neccessary fields of created question" do
          %w[id title body created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
        end
      end
    end
  end
  
  describe "PATCH /api/v1/questions/:id" do
    let(:method)    { "patch" }
    let(:path)      { "/api/v1/questions/#{question.id}" }

    it_behaves_like "API Authenticable"
    it_behaves_like "API Authorizable"
    it_behaves_like "API Validatable"

    context "when authenticated" do
      context "when authorized" do
        context 'with valid params' do
          before { do_request(method, path, params: { id: question, question: attributes_for(:question, body: "corrections"), access_token: access_token.token }, headers: headers) }

          it "return successfull status" do
            expect(response).to be_successful
          end

          it "returns all neccessary fields of updated question" do
            expect(question_response['body']).to eq assigns(:question).reload.body
            %w[id title body created_at updated_at].each do |attr|
              expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
            end
          end
        end
      end
    end
  end

  describe "DELETE /api/v1/questions/:id" do
    let(:method)    { "delete" }
    let(:path)      { "/api/v1/questions/#{question.id}" }

    it_behaves_like "API Authenticable"
    it_behaves_like "API Authorizable"

    context "when authenticated" do
      context "when authorized" do
        before { do_request(method, path, params: { id: question, access_token: access_token.token }, headers: headers) }

        it "return successfull status" do
          expect(response).to be_successful
        end

        it "deletes record" do
          expect(assigns(:question).persisted?).to be_falsey
        end
      end
    end
  end
end