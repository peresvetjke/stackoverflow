class Omni::AuthFinder
  attr_reader :provider, :uid, :email

  def initialize(auth)
    @provider = auth.provider
    @uid = auth.uid
    @email = auth.info.email
  end


  def call
    authentification = Authentification.find_or_initialize_by(provider: provider, uid: uid)
    user = authentification.user if authentification.persisted?
    
    unless user
      user = User.create!(email: email, password: Devise.friendly_token[0, 20], confirmed_at: Time.now)
      user.authentifications.create!(provider: provider, uid: uid)
    end

    user
  end
end