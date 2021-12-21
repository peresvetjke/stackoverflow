shared_examples_for 'API Linkable' do  
  let(:links_response) { json[linkable.class.name.downcase]['links'] }

  it "returns all associated links" do
    expect(links_response.count).to eq linkable.reload.links.count
  end

  it "returns neccessary fields for links" do
    %w[title url].each do |attr|
      expect(links_response.first[attr]).to eq linkable.reload.links.first.send(attr).as_json
    end
  end
end