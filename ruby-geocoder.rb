#Geocode our data

require 'geocoder'
require 'csv'

output = []

CSV.foreach("merged-final.csv", headers: true) do |row|
	address = row['address']
	city = row['city']
	state = row['state']
	zip = row['zip-leading-zero']

	location = [address, city, state, zip]
	# output << location
	# output << nil
	puts location.join(', ')
	output << Geocoder.coordinates(location.join(', '))
	sleep 0.5
end

output.map! {|e| e ? e : [0,0] }

CSV.open("output.csv", "w") do |csv|
	output.each do |i|
		csv << i
	end
end
