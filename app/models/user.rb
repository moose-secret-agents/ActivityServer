class User < ActiveRecord::Base
  has_secure_password
  has_many :training_sessions

  #returns nil if unsuccessful and the user if successful
  def self.try_authenticate_or_retrieve(username, password)
    client = Coach::Client.new

    if client.users.authenticated?(username, password)
      user = User.find_or_create_by(username: username) do |new_user|
        new_user.password = password
      end
      user
    else
      nil
    end
  end

end
