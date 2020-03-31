class Plant < ActiveRecord::Base
  has_many :user_plants
  has_many :users, through: :user_plants
  has_many :water_events
  has_many :fert_events

  def calc_water_schedule
    self.water = "whoops"

  end

  def water_schedule?
    self.water_track && self.water_events.count > 1
  end
  
  def calc_fert
    
  end

  def can_track_fert?

  end

end
