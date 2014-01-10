require 'erb'
require 'disc_jockey'

Dir[File.expand_path('../../models/*.rb',__FILE__)].each do |file| 
  require file 
end

include DiscJockey

class EmailBuilder
end

describe EmailBuilder do
	# Prepare tests
	before(:all) do

		@db = DBManager.new("spec/test_data")

		class DJScore
			attr_accessor :dj, :score
			def initialize(dj, score)
				@dj = dj
				@score = score
			end
		end

		@djs_match = []
		%W{John Jack James Jim Joe}.each do |dj|
			@djs_match << DJScore.new(dj, rand(5))
		end
		@djs_match.sort! {|x,y| x.score <=> y.score}.reverse!
		@max_score = @djs_match.max { |x,y| x.score <=> y.score}

		@user = User.new do |u| 
			u.firstname = "Hans"
			u.name = "Meier"
			u.email = "hans.meier@aol.com"
			u.tel = "01234567890"
		end

		@wish = Wish.new do |w|
			w.background_musik = "Chillout"
			w.tanzmusik_genre = "Aktuelle Charts: Passt Super;POP International: Passt Super;POP Deutsch: Lieber nicht;Rock Oldies: Lieber nicht;Rock Modern: Passt Super;Rock Deutsch: Passt Super;Alternative: Passt Super;Soul/Funk: Lieber nicht;Latino: Lieber nicht;House/Techno: Lieber nicht;Hip Hop International: Lieber nicht;Hip Hop Deutsch: Lieber nicht;World-Musik: Lieber nicht;Kölsches Tön: Lieber nicht;Schlager/NDW: Lieber nicht;Mallorca/Apres-Ski: Lieber nicht;Standard-Tänze: Lieber nicht"
			w.tanzmusik_zeit = "20/30/40er Jahre: Lieber nicht;50/60er Jahre: Lieber nicht;70er Jahre: Lieber nicht;80er Jahre: Lieber nicht;90er Jahre: Passt Super;2000 bis heute: Passt Super"
		end

		@event = Event.new do |e|
			e.stadt = "Berlin"
			e.strasse = "Hauptstrasse 1"
			e.anzahl = 20
			e.anzahl20 = 3
			e.anzahl60 = 10
			e.equipment = true
			e.beratung = true
			e.kommentar = "Habe keine weiteren <b>Anmerkungen</b>."
		end

		@event_date = "28. Aug 2014"
		@event_time = "18:00h"

		@email_report = File.join(File.dirname(__FILE__), 'email.html')
		@email_template = File.join(File.dirname(__FILE__), "email.html.erb")

		erb = ERB.new(File.read(@email_template))
		body_html =  erb.result(binding)
		File.open(@email_report, 'w') do |f|
			f.write(body_html)
		end
	end

	# Tests
	it "renders the html email file from template" do
		expect(File.exists?(@email_report)).to be true
	end

	it "max score should be greater 0" do
		expect(@max_score.score).to be > 0
	end

	it "one DJ from list shoud have max score" do
		expect(%W{John Jack James Jim Joe}).to include(@max_score.dj)
	end

	it "list of matching DJs should have 5 items" do
		expect(@djs_match.length).to be 5
	end
end
