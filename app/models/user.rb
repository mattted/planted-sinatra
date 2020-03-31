class User < ActiveRecord::Base
  has_secure_password
  validates :email, uniqueness: true
  validates :username, uniqueness: true
  validates :email, presence: true

  has_many :user_plants
  has_many :plants, through: :user_plants

end
