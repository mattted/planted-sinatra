class Plant < ActiveRecord::Base
  has_many :user_plants
  has_many :users, through: :user_plants
  has_many :water_events
  has_many :fert_events

  def calc_avg_water_schedule
    dates = self.water_events.all.map{ |ev| ev.date }.sort
    diff = Array.new

    dates.each_with_index{ |d, i| diff << d - dates[i -1] if i != 0 }
    diff.length > 1 ? avg = diff.inject(:+).to_f / (diff.size - 1) : avg = diff.first.to_f
    self.water_avg = avg.round(2)
  end

  def water_avg?
    self.water_track && self.water_events.count > 1
  end

  def set_water_due_date
    if self.water_events.count > 0
      most_recent = self.water_events.sort_by(&:date).reverse.first.date      
      self.water_due = most_recent + water_avg 
    else
      self.water_due = self.created_at.to_date + water_avg
    end
  end

  def due_in_on
    days = (self.water_due - DateTime.now.to_date).to_f.round(0)
    if days == 0
      "Water Today"
    elsif days == 1
      "Water Tomorrow"
    elsif days == -1
      "1 Day Overdue"
    elsif days > 1
      "Water in #{days} Days"
    elsif days < -1
      "#{days.abs} Days Overdue"
    end
  end

end
