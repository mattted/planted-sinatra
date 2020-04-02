class User < ActiveRecord::Base
  has_secure_password
  validates :email, uniqueness: true
  validates :username, uniqueness: true
  validates :email, presence: true

  has_many :user_plants
  has_many :plants, through: :user_plants
  has_many :water_events, through: :plants

  def recent_plants
    self.plants.sort_by(&:updated_at).reverse[0..3]
  end

  def overdue_plants
    self.plants.select{ |plant| plant.water_due <= DateTime.now }.sort_by(&:water_due)
  end


end
