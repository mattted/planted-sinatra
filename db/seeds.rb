require 'csv'
require 'pry'


csv_text = File.read(__dir__ + '/csv/Plants19-11-26.csv')
csv = CSV.parse(csv_text, headers: true)
user = User.first
csv.each do |row|
  hash = row.to_hash
  hash["date"] = hash["date"].to_date
  hash["water"] = hash["water"].to_f
  hash["fert"] = hash["fert"].to_f
  plant = user.plants.build(hash.except("water_array", "fert_date_csv"))
  user.save

  hash["water_array"].split(/'/).select{ |elem| elem[0] == "2" }.each do |elem|
    wevent = plant.water_events.build({date: elem.to_date + 145, notes: "seeded water data"})
    plant.save
  end
end
