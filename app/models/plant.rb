class Plant < ActiveRecord::Base
  has_many :user_plants
  has_many :users, through: :user_plants
  has_many :water_events
  has_many :fert_events

  def calc_water
    
  end

  def can_track_water?

  end
  
  def calc_fert
    
  end

  def can_track_fert?

  end

end
