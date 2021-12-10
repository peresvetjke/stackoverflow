require "rails_helper"

RSpec.describe OmniauthCallbacksController, :type => :controller do
  
  before do 
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'github' do
    
  end

  describe 'facebook' do

  end
end
