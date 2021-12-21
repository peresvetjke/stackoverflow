shared_examples "it_renders" do |template|
  it "renders #{template.to_s} template" do
    subject
    expect(response).to render_template(template)
  end
end

shared_examples "it_returns_status" do |status|
  it "returns #{status.to_s} status" do
    subject
    expect(response.status).to eq status
  end
end