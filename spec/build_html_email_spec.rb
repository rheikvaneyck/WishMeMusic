require 'erb'

class EmailBuilder
end

describe EmailBuilder do
	it "html_email_builder renders the html email file from template" do
		class User
			attr_accessor :firstname, :name, :email, :tel
			def initialize
				@firstname = "Hans"
				@name = "Meier"
				@email = "hans.meier@aol.com"
				@tel = "01234567890"
			end
		end
		class Wish
			attr_accessor :background_musik, :tanzmusik_genre, :tanzmusik_zeit
			def initialize
				@background_musik = "Chillout"
				@tanzmusik_genre = "Aktuelle Charts: Passt Super;POP International: Passt Super;POP Deutsch: Lieber nicht;Rock Oldies: Lieber nicht;Rock Modern: Passt Super;Rock Deutsch: Passt Super;Alternative: Passt Super;Soul/Funk: Lieber nicht;Latino: Lieber nicht;House/Techno: Lieber nicht;Hip Hop International: Lieber nicht;Hip Hop Deutsch: Lieber nicht;World-Musik: Lieber nicht;Kölsches Tön: Lieber nicht;Schlager/NDW: Lieber nicht;Mallorca/Apres-Ski: Lieber nicht;Standard-Tänze: Lieber nicht"
				@tanzmusik_zeit = "20/30/40er Jahre: Lieber nicht;50/60er Jahre: Lieber nicht;70er Jahre: Lieber nicht;80er Jahre: Lieber nicht;90er Jahre: Passt Super;2000 bis heute: Passt Super"
			end
		end
		class Event
			attr_accessor :id, :stadt, :strasse, :anzahl, :anzahl20, :anzahl60, :equipment, :beratung, :kommentar
			def initialize
				@id = "1"
				@stadt = "Berlin"
				@strasse = "Hauptstrasse 1"
				@anzahl = 20
				@anzahl20 = 3
				@anzahl60 = 10
				@equipment = true
				@beratung = true
				@kommentar = "Habe keine weiteren <b>Anmerkungen</b>."
			end
		end
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

		@user = User.new
		@wish = Wish.new
		@event = Event.new

		@event_date = "28. Aug 2014"
		@event_time = "18:00h"


		erb = ERB.new(File.read(File.join(File.dirname(__FILE__), "email.html.erb")))
		body_html =  erb.result(binding)
		File.open(File.join(File.dirname(__FILE__), 'email.html'), 'w') do |f|
			f.write(body_html)
		end

		File.exists?(File.join(File.dirname(__FILE__), 'email.html'))
	end
end
