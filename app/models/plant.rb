class Plant < ActiveRecord::Base
  has_many :user_plants
  has_many :users, through: :user_plants
  has_many :water_events
  has_many :fert_events

  def calc_water_schedule
    dates = self.water_events.all.map{ |ev| ev.date }.sort
    diff = Array.new

    dates.each_with_index{ |d, i| diff << d - dates[i -1] if i != 0 }
    avg = diff.inject(:+).to_f / (diff.size - 1)
    self.water = avg.round(2)
  end

  def water_schedule?
    self.water_track && self.water_events.count > 1
  end
  
  def calc_fert
    
  end

  def can_track_fert?

  end

end
