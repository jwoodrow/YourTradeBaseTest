require_relative '../../models/person'

RSpec.describe Person, "#validators" do
	before {
		@person = Person.new "156asdasd", 42, {"first" => "John", "last" => "Doe"}, {"latitude" => "-42", "longitude" => "42"}, "company_name", "local@domain.tld", "423 Auburn Place, Sanders, Texas, 5269", "England"
	}
	context "Can create an instance and it" do
		it "is valid" do
			expect(@person.valid?).to be true
		end
	end

	context "Cannot create a valid instance because it" do
		# id
		it "doesn't have an id" do
			@person.id = nil
			expect(@person.valid?).to be false
		end
		it "has an empty id" do
			@person.id = ""
			expect(@person.valid?).to be false
		end
		# value
		it "has an empty value" do
			@person.value = nil
			expect(@person.valid?).to be false
		end
		it "has a value that isn't a number" do
			@person.value = "NaN"
			expect(@person.valid?).to be false
		end
		# name
		it "doesn't have a name" do
			@person.name = nil
			expect(@person.valid?).to be false
		end
		it "doesn't have a firstname" do
			@person.name[:first] = nil
			expect(@person.valid?).to be false
		end
		it "has an empty firstname" do
			@person.name[:first] = ""
			expect(@person.valid?).to be false
		end
		it "doesn't have a lastname" do
			@person.name[:last] = nil
			expect(@person.valid?).to be false
		end
		it "has an empty lastname" do
			@person.name[:last] = ""
			expect(@person.valid?).to be false
		end
		# location
		it "doesn't have a location" do
			@person.location = nil
			expect(@person.valid?).to be false
		end
		it "doesn't have a latitude" do
			@person.location[:latitude] = nil
			expect(@person.valid?).to be false
		end
		it "has a latitude that is too low" do
			@person.location[:latitude] = -91
			expect(@person.valid?).to be false
		end
		it "has a latitude that is too high" do
			@person.location[:latitude] = 91
			expect(@person.valid?).to be false
		end
		it "doesn't have a longitude" do
			@person.location[:longitude] = nil
			expect(@person.valid?).to be false
		end
		it "has a longitude that is too low" do
			@person.location[:longitude] = -181
			expect(@person.valid?).to be false
		end
		it "has a longitude that is too high" do
			@person.location[:longitude] = 181
			expect(@person.valid?).to be false
		end
		# company
		it "doesn't have a company" do
			@person.company = nil
			expect(@person.valid?).to be false
		end
		it "has an empty company" do
			@person.company = ""
			expect(@person.valid?).to be false
		end
		#email
		it "doesn't have an email" do
			@person.email = nil
			expect(@person.valid?).to be false
		end
		it "has an empty email" do
			@person.email = ""
			expect(@person.valid?).to be false
		end
		it "doesn't have a valid email format" do
			["@domain.tld", "local.tld", "local@@domain.tld"].each do |test_email|
				@person.email = test_email
				if @person.valid?
					puts test_email
				end
				expect(@person.valid?).to be false
			end
		end
		#address
		it "doesn't have a address" do
			@person.address = nil
			expect(@person.valid?).to be false
		end
		it "has an empty address" do
			@person.address = ""
			expect(@person.valid?).to be false
		end
		#country
		it "doesn't have a country" do
			@person.country = nil
			expect(@person.valid?).to be false
		end
		it "has an empty country" do
			@person.country = ""
			expect(@person.valid?).to be false
		end
	end
end

RSpec.describe Person, "#calculations" do
	context "Can calculate distance between itself" do 
		it "and Bristol" do
			@person = Person.new "156asdasd", 42, {"first" => "John", "last" => "Doe"}, {"latitude" => "51.077801", "longitude" => "-3.082931"}, "company_name", "local@domain.tld", "423 Auburn Place, Sanders, Texas, 5269", "England"
			@bristol_latitude = 51.450167
			@bristol_longitude = -2.594678
			expect(@person.distance_from(@bristol_latitude, @bristol_longitude)).to eq 53.55791130847151
		end
	end
end