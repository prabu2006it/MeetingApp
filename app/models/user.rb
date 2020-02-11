class User < ApplicationRecord

  has_many :meetings

  has_secure_password

  enum role: {"Normal User": 1}

  # DoorKeeper Access Token
  def get_access_token(app)
    Doorkeeper::AccessToken.where(application_id: app.id, resource_owner_id: id).destroy_all
    access_token = Doorkeeper::AccessToken.find_or_create_for(app, id, 'user read and write preference', 8.hours, true)
    return access_token
  end


end
