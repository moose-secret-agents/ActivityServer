class User < ActiveRecord::Base
  has_secure_password
  has_many :training_sessions
  #returns nil if unsuccessful and the user if successful
  def self.try_authenticate_or_retrieve(username, password)
    coachUser = Coach::User.authenticate(username,password)
    return nil if coachUser.nil? or coachUser.password.nil?
    user = User.find_by(username: username)
    if user.nil?
      user =User.create(username: username, password: password)
    else
      user.password = password
      user.save
    end
    user
  end

end
