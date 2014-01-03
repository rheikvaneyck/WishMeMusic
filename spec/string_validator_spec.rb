require File.join(File.dirname(__FILE__),'..','helpers','valid_string_helper')

class StringValidator
	include ValidStringHelper
end

describe StringValidator do
	# Tests for names

	before(:all) do
		@names = ["James", 
			"<xml-code>", 
			"\'code injection\'", 
			"Müller", 
			"René", 
			"O'Reilly",
			"Müller-Lüdenscheid",
			"-Lüdenscheid",
			"#()§$\'"
		]
	end

	it "extracts only valid strings for names from input" do
		expect(@names[0].filter_purpose(:name)).to eq("James")
	end
	
	it "should filter xml-code from input" do
		expect(@names[1].filter_purpose(:name)).to eq("xml-code")
	end

	it "should avoid code injection" do
		expect(@names[2].filter_purpose(:name)).to eq("code injection")
	end

	it "should regognize umlauts" do
		expect(@names[3].filter_purpose(:name)).to eq("Müller")
	end

	it "should regonize accent aigu" do
		expect(@names[4].filter_purpose(:name)).to eq("René")
	end
	
	it "should regonize apostrophes in names" do
		expect(@names[5].filter_purpose(:name)).to eq("O'Reilly")
	end

	it "should regonize combined names" do
		expect(@names[6].filter_purpose(:name)).to eq("Müller-Lüdenscheid")
	end

	it "should ignore starting symbols" do
		expect(@names[7].filter_purpose(:name)).to eq("Lüdenscheid")
	end

	it "should ignore starting symbols" do
		expect(@names[8].filter_purpose(:name)).to be_empty
	end
end

describe StringValidator do
	# Test for emails
	# but don't accept string which are not emails

	before(:all) do
		@emails = ["harry.klein@gmail.com",
			"liese1981@aol.com",
			"dr.klein@labs.dach.acme.com",
			"James Johnson <<james.johnson@yahoo.com>>",
			"Jack Ripper"
		]
	end

	it "extracts valid emails" do
		expect(@emails[0].filter_purpose(:email)).to eq("harry.klein@gmail.com")
	end

	it "extracts valid emails with numbers" do
		expect(@emails[1].filter_purpose(:email)).to eq("liese1981@aol.com")
	end

	it "extracts valid emails with numbers" do
		expect(@emails[2].filter_purpose(:email)).to eq("dr.klein@labs.dach.acme.com")
	end

	it "extracts valid emails with numbers" do
		expect(@emails[3].filter_purpose(:email)).to eq("james.johnson@yahoo.com")
	end

	it "extracts valid emails with numbers" do
		expect(@emails[4].filter_purpose(:email)).to be_empty
	end
end

describe StringValidator do
	# Test for valid phone numbers
	# to accept all possible entries users could make 
	# but avoid fake or malicious input
	before(:all) do
		@tel = [
			"+49 (0)30 12345677",
			"0049 (0)30 12345677",
			"0049 30 12345677",
			"+4930/12345677",
			"030/12345689",
			"+61 1 2345 6789",
			"+61 01 2345 6789",
			"01 2345 6789",
			"01-2345-6789",
			"(01) 2345 6789",
			"(01) 2345-6789",
			"1234 5678",
			"1234-5678",
			"12345678",
			"0123 456 789",
			"0123456789",
			"+1 (012) 456 7890",
			"+1-340 123 4567"
		]
	end

	it "extracts valid phone numbers" do
		@tel.each do |t|
			expect(t.filter_purpose(:tel)).to eq(t)
		end
	end
end

describe StringValidator do
	# Test for valid date entries
	# to accept all possible entries users could make 
	# but avoid fake or malicious input
	before(:all) do
		@daten = [
			"01.01.2013",
			"1.01.2013",
			"1.1.2013",
			"1.1.13",
			"1.01.13",
			"01/01/2013",
			"01-01-2013",
			"01 01 2013",
			"1. August 2013",
			"1. Aug 2013",
			"1. August 13",
			"01.August 2013",
			"01. August 2013"
		]
	end
	it "extracts valid dates" do
		@daten.each do |d|
			expect(d.filter_purpose(:datum)).to eq(d)
		end
	end
end

describe StringValidator do
	# Test for valid time entries
	# to accept all possible entries users could make 
	# but avoid fake or malicious input
	before(:all) do
		@daten = [
			"18:00",
			"18.00",
			"18/00",
			"18-00",
			"8:00",
			"8.0",
			"1800",
			"18",
		]
	end
	it "extracts valid dates" do
		@daten.each do |d|
			expect(d.filter_purpose(:zeit)).to eq(d)
		end
	end
end
describe StringValidator do
	# Test for valid street entries
	# to accept all possible entries users could make 
	# but avoid fake or malicious input
	before(:all) do
		@daten = [
			"Am Plan 3c",
			"Hauptstr. 4 1/2",
			"A-Weg 8"
		]
	end
	it "extracts valid streets" do
		@daten.each do |d|
			expect(d.filter_purpose(:street)).to eq(d)
		end
	end
end
describe StringValidator do
	# Test for valid city entries
	# to accept all possible entries users could make 
	# but avoid fake or malicious input
	before(:all) do
		@daten = [
			"Berlin",
			"Halle/Saale",
			"Frankfurt am Main",
			"München a. d. Isar"
		]
	end
	it "extracts valid streets" do
		@daten.each do |d|
			expect(d.filter_purpose(:city)).to eq(d)
		end
	end
end