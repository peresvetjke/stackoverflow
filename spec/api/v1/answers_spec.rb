require "rails_helper"

describe "Answers API", type: :request do
  let(:headers)          {{ "ACCEPT"       => "application/json" }}
  let!(:resource_owner)  { create(:user) }
  let(:access_token)     { create(:access_token, resource_owner_id: resource_owner.id) }
  let!(:answer)          { create(:answer, author: resource_owner)}
  let(:question)         { answer.question }
  let(:answer_response)  { json["answer"] }
  let(:answers_response) { json["answers"] }

  %i[validatable authorizable commentable linkable attachable].each do |able|
    let(able) { answer }
  end

  describe "GET /api/v1/questions/:question_id/answers" do
    let(:method)            { "get" }
    let(:path)              { "/api/v1/questions/#{answer.question.id}/answers" }
    let!(:answers)          { create_list(:answer, 4, question: question) }

    it_behaves_like "API Authenticable"

    context "when authenticated" do
      before { do_request("get", path, params: { access_token: access_token.token }, headers: headers) }

      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all answers by selected question" do
        expect(answers_response.map{ |a| a['id'] }.sort).to eq question.answers.ids.sort
      end

      it "returns all neccessary fields" do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(answers_response.first[attr]).to eq question.answers.first.send(attr).as_json
        end
      end
    end
  end

  describe "GET /api/v1/answers/:id" do
    let(:method)          { "get" }
    let(:path)            { "/api/v1/answers/#{answer.id}" }
    let!(:answer)         { create(:answer, :with_link, :with_comments) }

    before                { attach_files_to(answer, 2) }

    it_behaves_like "API Authenticable"

    context "when authenticated" do
      before { do_request("get", path, params: { access_token: access_token.token }, headers: headers) }

      it "returns 200 status" do
        expect(response.status).to eq 200
      end

      it "returns all neccessary fields" do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it_behaves_like "API Commentable"      
      it_behaves_like "API Linkable"      
      it_behaves_like "API Attachable"
    end
  end

  describe "POST /api/v1/questions/:id/answers" do
    let(:method)    { "post" }
    let(:path)      { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like "API Authenticable"
    it_behaves_like "API Validatable"

    context "when authenticated" do
      context 'with valid params' do
        before { do_request(method, path, params: { answer: attributes_for(:answer), access_token: access_token.token }, headers: headers) }

        it "return status 'created'" do
          expect(response.status).to eq 201
        end

        it "returns all neccessary fields of created answer" do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq assigns(:answer).send(attr).as_json
          end
        end
      end
    end
  end

  describe "PATCH /api/v1/answers/:id" do
    let(:method)    { "patch" }
    let(:path)      { "/api/v1/answers/#{answer.id}" }

    it_behaves_like "API Authenticable"
    it_behaves_like "API Authorizable"
    it_behaves_like "API Validatable"

    context "when authenticated" do
      context "when authorized" do
        context 'with valid params' do
          before { do_request(method, path, params: { id: answer, answer: attributes_for(:answer, body: "corrections"), access_token: access_token.token }, headers: headers) }

          it "return successfull status" do
            expect(response).to be_successful
          end

          it "returns all neccessary fields of updated question" do
            expect(answer_response['body']).to eq assigns(:answer).reload.body
            %w[id body author_id created_at updated_at].each do |attr|
              expect(answer_response[attr]).to eq assigns(:answer).send(attr).as_json
            end
          end
        end
      end
    end
  end


  describe "DELETE /api/v1/answers/:id" do
    let(:method)    { "delete" }
    let(:path)      { "/api/v1/answers/#{answer.id}" }

    it_behaves_like "API Authenticable"
    it_behaves_like "API Authorizable"

    context "when authenticated" do
      context "when authorized" do
        before { do_request(method, path, params: { id: answer, access_token: access_token.token }, headers: headers) }

        it "return successfull status" do
          expect(response).to be_successful
        end

        it "deletes record" do
          expect(assigns(:answer).persisted?).to be_falsey
        end
      end
    end
  end
end