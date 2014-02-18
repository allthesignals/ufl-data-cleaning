require 'json'
require 'open-uri'
require 'csv'

# json['code'], json['title'], json['description'], json['examples']
data = []
hash = Hash.new("undefined")
hash = {"code" => [], "title" => [], "description" => [], "examples" => [] }

CSV.foreach("merged-final.csv", headers: true) do |r|
	naics = r['primary-naics']
	data << naics
end

uniques = data.uniq.compact

uniques.each do |r|
	resource = "http://api.naics.us/v0/q?year=2012&code=" + r.to_s
	parse = URI.parse(resource)
	json = JSON.parse(parse.read)
	hash["code"] << json['code']
	hash["title"] << json['title']
	hash["description"] << json['description']
	hash["examples"] << json['examples']
end

CSV.open("api-output.csv", "wb") {|csv| hash.to_a.each {|elem| csv << elem} }