require 'rails_helper'
# let(:seri)

RSpec.describe DailyDigestJob, type: :job do
  it "calls Daily Digest Service" do
    allow_any_instance_of(DailyDigest).to receive(:send_digest)
    DailyDigestJob.perform_now
  end
end
