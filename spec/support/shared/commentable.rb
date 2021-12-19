shared_examples_for 'API Commentable' do  
  let(:comments_response) { json[commentable.class.name.downcase]['comments'] }

  it "returns all associated comments" do
    expect(comments_response.map{ |c| c['id'] }.sort).to eq commentable.comments.ids.sort
  end

  it "returns neccessary fields for comments" do
    %w[id body author_id created_at updated_at].each do |attr|
      expect(comments_response.first[attr]).to eq commentable.comments.first.send(attr).as_json
    end
  end
end