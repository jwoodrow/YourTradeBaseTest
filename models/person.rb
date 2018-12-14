require 'json'
require 'active_model'

# Define constant for earth's radius in km
R = 6371
class Person
  include ActiveModel::Validations

  attr_accessor :id, :value, :company, :email, :address, :country
  attr_reader :name, :location

  validates_presence_of :id, :value, :name, :location, :company, :email, :address, :country
  validates_numericality_of :value
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validate :has_first_and_last_name, :has_valid_location

  def initialize(id, value, name, location, company, email, address, country)
    self.id = id
    self.value = value.to_i
    self.name = name
    self.location = location
    self.company = company
    self.email = email
    self.address = address
    self.country = country
    @errors = ActiveModel::Errors.new(self)
  end

  def name=(name)
    if name.nil?
      @name = name
    else
      @name = {
        first: name["first"] || name[:first],
        last: name["last"] || name[:last]
      }
    end
  end

  def location=(location)
    if location.nil?
      @location = nil
    else
      latitude = location["latitude"].to_f || location[:latitude].to_f
      longitude = location["longitude"].to_f || location[:longitude].to_f
      @location = {
        latitude: latitude,
        longitude: longitude
      }
    end
  end

  def fullname
    "#{name[:first]} #{name[:last]}"
  end

  def fullname=(fullname)
    split_name = fullname.split(" ")
    @name = {
      first: split_name[0],
      last: split_name[1]
    }
    # Returning the new fullname for chaining
    fullname()
  end

  def distance_from(latitude, longitude)
    # The haversine formula: d = R * c
    # Where: 
    # c = 2 ⋅ atan2( √a, √(1−a) )
    # And
    # a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)
    _self_phi = location[:latitude] * Math::PI / 180.0
    _other_phi = latitude * Math::PI / 180.0
    _delta_phi = (latitude - location[:latitude]) * Math::PI / 180.0
    _delta_lambda = (longitude - location[:longitude]) * Math::PI / 180.0

    _a = (Math.sin(_delta_phi / 2.0) ** 2) + (Math.cos(_self_phi) * Math.cos(_other_phi)) * (Math.sin(_delta_lambda / 2.0) ** 2)
    _c = 2.0 * Math.atan2(Math.sqrt(_a), Math.sqrt(1 - _a))

    R * _c
  end

  def to_hash
    {
      id: id,
      fullname: fullname,
      value: value,
      email: email
    }
  end

  def to_json
    to_hash.to_json
  end

  def has_first_and_last_name
    unless name.nil?
      if name[:first].nil?
        @errors.add :name, "No firstname given"
      elsif name[:first].empty?
        @errors.add :name, "Firstname cannot be empty"
      end
      if name[:last].nil?
        @errors.add :name, "No lastname given"
      elsif name[:last].empty?
        @errors.add :name, "Lastname cannot be empty"
      end
    end
  end

  def has_valid_location
    unless location.nil?
      # Check if we have both a latitude and a longitude
      if location[:latitude].nil?
        @errors.add :location, "No latitude given"
      end
      if location[:longitude].nil?
        @errors.add :location, "No longitude given"
      end
      # Check if we have numbers for latitude and longitude
      if !location[:latitude].is_a? Numeric
        @errors.add :location, "Latitude is not a float"
      end
      if !location[:longitude].is_a? Numeric
        @errors.add :location, "Longitude is not a float"
      end
      # Check if latitude is valid
      if location[:latitude].to_f < -90
        @errors.add :location, "Latitude is below -90"
      end
      if location[:latitude].to_f > 90
        @errors.add :location, "Latitude is above 90"
      end
      # Check if longitude is valid
      if location[:longitude].to_f < -180
        @errors.add :location, "Longitude is below -180"
      end
      if location[:longitude].to_f > 180
        @errors.add :location, "Longitude is above 180"
      end
    end
  end
end