class User < ApplicationRecord

  has_many :meetings
  
  after_save :update_username
  # DoorKeeper Access Token
  def get_access_token(app)
    Doorkeeper::AccessToken.where(application_id: app.id, resource_owner_id: id).destroy_all
    access_token = Doorkeeper::AccessToken.find_or_create_for(app, id, 'user read and write preference', 8.hours, true)
    return access_token
  end

  private

  def update_username
  	self.update_column("username", first_name.to_s + + last_name.to_s)
  end


end
