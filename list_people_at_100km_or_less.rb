#!/Users/feilsafe/.rvm/rubies/ruby-2.5.3/bin/ruby
require 'json'
require 'pathname'
require_relative './models/person'

# Check if an argument was given
if ARGV.length <= 0
  STDERR.puts "No csv file given. usage is `./find_nearest.rb file_path"
  exit 2
end

# Check if the argument is a file path that exists
path = Pathname "#{Dir.pwd}/#{ARGV[0]}"
if !path.exist?
  STDERR.puts "File not found"
  exit 1
end

# Simple method to validate if a given string is a JSON or not

def valid_json?(json)
    JSON.parse json
    return true
  rescue JSON::ParserError => e
    return false
end

file_content = File.read "#{Dir.pwd}/#{ARGV[0]}"

# Check if the file given is a valid JSON file
if !valid_json?(file_content)
  STDERR.puts "Not a valid json file"
  exit 3
end

# Load up the hash
json_hash = JSON.parse file_content

# Convert the json hash to an array of People
people = json_hash.map do |person|
  Person.new person["id"], person["value"], person["name"], person["location"], person["company"], person["email"], person["address"], person["country"]
end

# Using a variable for the distance and for Bristol GPS coordinates
max_distance = 100
origin_latitude = 51.450167
origin_longitude = -2.594678

filtered_people = people.select do |person|
  person.valid? && person.distance_from(origin_latitude, origin_longitude) <= max_distance && person.country.downcase == "england"
end.sort_by { |person| person.value }.reverse

puts filtered_people.map { |person| person.to_hash }.to_json