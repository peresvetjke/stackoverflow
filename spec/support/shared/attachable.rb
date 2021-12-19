shared_examples_for 'API Attachable' do  
  let(:attachments_response) { json[attachable.class.name.downcase]['attachments'] }

  it "returns all associated attachments" do
    expect(attachments_response.count).to eq question.files.count
  end

  it "returns neccessary fields for attachments" do
    expect(attachments_response).to match_array(question.files.map{ |file| url_for(file) })
  end
end