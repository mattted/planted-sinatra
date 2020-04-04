require 'csv'
require 'pry'


User.create({username: "UserOne", email: "userone@test.com", password: "nothing"})
User.create({username: "UserTwo", email: "usertwo@test.com", password: "nothing"})

csv_text = File.read(__dir__ + '/csv/seeds.csv')
csv = CSV.parse(csv_text, headers: true)
userone = User.all.first
usertwo = User.all.last
csv.each_with_index do |row, i|
  if i <= 30
    hash = row.to_hash
    hash["date"] = (hash["date"] + " 2019").to_date
    # hash["date"] = hash["date"].to_date
    hash["water_avg"] = hash["water_avg"].to_f
    hash["fert_avg"] = hash["fert_avg"].to_f
    plant = userone.plants.build(hash.except("water_array", "fert_date_csv"))
    userone.save

    hash["water_array"].split(/'/).select{ |elem| elem[0] == "2" }.each do |elem|
      wevent = plant.water_events.build({date: elem.to_date + 147, notes: "seeded water data"})
      plant.save
    end
   
    Array.new(10).map.with_index { |_, i| DateTime.now.to_date - (rand(30..60) * (i + 1)) }.sort.each do |elem|
      fevent = plant.fert_events.build({ date: elem.to_date, notes: "seeded fertilizer data" })
      plant.save
    end
  end
end

csv.each_with_index do |row, i|
  if i > 30
    hash = row.to_hash
    hash["date"] = (hash["date"] + " 2019").to_date
    # hash["date"] = hash["date"].to_date
    hash["water_avg"] = hash["water_avg"].to_f
    hash["fert_avg"] = hash["fert_avg"].to_f
    plant = usertwo.plants.build(hash.except("water_array", "fert_date_csv"))
    usertwo.save

    hash["water_array"].split(/'/).select{ |elem| elem[0] == "2" }.each do |elem|
      wevent = plant.water_events.build({date: elem.to_date + 145, notes: "seeded water data"})
      plant.save
    end
   
    Array.new(10).map.with_index { |_, i| DateTime.now.to_date - (rand(1..30) * (i + 1)) }.sort.each do |elem|
      fevent = plant.fert_events.build({ date: elem.to_date, notes: "seeded fertilizer data" })
      plant.save
    end
  end
end
