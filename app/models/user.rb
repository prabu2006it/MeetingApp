class User < ApplicationRecord

  has_many :meetings

  enum role: {"Normal User": 1}

end
