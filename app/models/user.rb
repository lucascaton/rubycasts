class User
  include DataMapper::Resource
  
  property :id, Serial
  property :email, String
  property :encrypted_password, String, :length => 255

  property :admin, Boolean
  property :github_uid, String, :length => 255
  property :github_user, String, :length => 255
  property :name, String, :length => 255
  property :gravatar_id, String, :length => 255
  property :site, String, :length => 255
  
  # Get the encrypted_password for the User
  #
  def password
    @password ||= BCrypt::Password.new(encrypted_password)
  end
  
  # Encrypt the password before put in the Database
  #
  def password=(super_secret)
    @password = BCrypt::Password.create(super_secret)
    self.encrypted_password = @password
  end
  
  # Authenticate User
  #
  def self.authenticate!(params)
    user = User.first(:email => params[:email])
    if user
      user.check_the_password!(params[:password])
    else
      false
    end
  end
  
  # Check if the user password is equal to the secret_password
  #
  def check_the_password!(secret_password)
    return self if password == secret_password
    false
  end
  
  def self.create_from_omniauth!(omniauth_hash)
    User.new.tap do |user|
      user.email       = omniauth_hash['user_info']['email']
      user.github_uid  = omniauth_hash['uid']
      user.github_user = omniauth_hash['user_info']['nickname']
      user.name = omniauth_hash['user_info']['name']
      user.gravatar_id = omniauth_hash['extra']['user_hash']['gravatar_id']
      user.site = omniauth_hash['user_info']['urls']['Blog'] if omniauth_hash['user_info']['urls']
      user.admin = false
      user.save!
    end
  end
  
end
