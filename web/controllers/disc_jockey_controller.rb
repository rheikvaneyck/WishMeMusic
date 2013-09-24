require 'bundler/setup'
require 'haml'
require 'erb'
require 'pony'
require 'time'
require 'disc_jockey'

class DiscJockeyController < ApplicationController

  get '/' do
    haml :start
  end

  get '/hintergrund' do  
    @hintergr = ['Bar Jazz','Cafe del Mar', 'Chanson', 'Klassik', 'Kuba', 'Lounge', 'Aktuelles']
    haml :hintergrund
  end

  post '/hintergrund' do

    params.each do |key, value|
      if (key == 'Sonstiges') then
        session[:hintergrund] = params[:hintergrundwunsch]
      elsif (value == 'ok') then
        session[:hintergrund] = key
      end
    end
     redirect '/tanzmusik_zeit'
  end

  get '/tanzmusik_zeit' do
    @categories = ["Passt Super", "Geht so", "Lieber nicht"]
    @times = ['20/30/40er Jahre', '50/60er Jahre', '70er Jahre', '80er Jahre', '90er Jahre', '2000 bis heute']
    haml :tanzmusik_zeit
  end

  post '/tanzmusik_zeit' do
    # HINWEIS: keine Werte, wenn radiobutton nicht geklickt
    str = []
    params.each do |key, value|
      str << "#{key}: #{value}"
    end
    session[:tanzmusik_zeit] = str.join(";")
    redirect '/tanzmusik_genre'
  end

  get '/tanzmusik_genre' do
    @categories = ["Passt Super", "Geht so", "Lieber nicht"]
    @genres = ['Aktuelle Charts', 'POP International', 'POP Deutsch', 'Rock Oldies', 'Rock Modern', 'Rock Deutsch', 'Alternative', 'Soul/Funk', 'Latino', 'House/Techno', 'Hip Hop International', 'Hip Hop Deutsch','World-Musik', 'Kölsches Tön', 'Schlager/NDW', 'Mallorca/Apres-Ski', 'Standard-Tänze']     
    haml :tanzmusik_genre
  end

  post '/tanzmusik_genre' do
    str = []
    params.each do |key, value|
      str << "#{key}: #{value}"
    end    
    session[:tanzmusik_genre] = str.join(";")
  	redirect '/kundendaten'
  end

  get '/philosophie' do
  	haml :philosophie
  end

  get '/referenzen' do
  	haml :referenzen
  end

  get '/kundendaten' do
     haml :contact
  end

  post '/kundendaten' do
    @db = DiscJockey::DBManager.new

    lastname = (params[:name]).split(" ").last unless params[:name].nil?
    surname = (params[:name]).split(" ")
    surname.delete(lastname) unless lastname.nil?
    surname = surname.join(" ")

    @u = DiscJockey::DBManager::User.find(:first, :conditions => [ "email = ?", params[:email]])
    
    @u = DiscJockey::DBManager::User.create(
      :email  => params[:email],
      :tel => params[:tel],
      :name => lastname,
      :firstname => surname,
      :email => params[:email],
      :role => 'user') if @u.nil?

    @w = DiscJockey::DBManager::Wish.create(
      :background_musik => session[:hintergrund], 
      :tanzmusik_genre => session[:tanzmusik_genre], 
      :tanzmusik_zeit => session[:tanzmusik_zeit], 
      :user_id => @u.id)

    @er = DiscJockey::DBManager::Event.new do |r|
      r.datum = params[:datum]
      r.zeit = params[:zeit]
      r.strasse = params[:strasse]
      r.stadt = params[:stadt]
      r.anzahl = params[:anzahl]
      r.anzahl20 = params[:unter20]
      r.anzahl60 = params[:ueber60]
      r.equipment = params[:equipment]
      r.beratung = params[:beratung]
      r.kommentar = params[:message]
      r.user_id = @u.id
      r.wish_id = @w.id
    end
    @er.save

    redirect "/abschluss?id=#{@er.id}"
  end
    
  get '/abschluss' do
    @id = params[:id]

    @db = DiscJockey::DBManager.new
    @event = DiscJockey::DBManager::Event.find(@id)
    @user = DiscJockey::DBManager::User.find(@event.user_id)
    @wish = DiscJockey::DBManager::Wish.find(@event.wish_id)

    @event_date = Time.parse(@event.datum.to_s).strftime("%d. %b %Y") unless @event.datum.nil?
    @event_time = Time.parse(@event.zeit.to_s).strftime("%H:%M") unless @event.zeit.nil?

=begin
    # FIXME: Pony sendet ENTWEDER plain text ODER html

    body_text = <<-END

    Event-ID: #{@event.id}
    Kunde: #{@user.firstname} #{@user.name}

    Event am: #{@event_date} um #{@event_time} Uhr
    
    Hintergrund-Musik: 
      #{@wish.background_musik.split(";").join("\n\t")}

    Tanzmusik Genre: 
      #{@wish.tanzmusik_genre.split(";").join("\n\t")}
    
    Tanzmusik Zeit: 
      #{@wish.tanzmusik_zeit.split(";").join("\n\t")}

    Kontakt: #{@user.email}
    END
=end
    # FIXME: In lib auslagern
    class DJScore
      attr_accessor :dj, :score
      def initialize(dj, score)
        @dj = dj
        @score = score
      end
    end

    # FIXME: Lege die Kategorien in der DB oderconfig ab!
    how_much = ["Nix", "Mittel", "Viel"]
    like_it = ["Lieber nicht", "Geht so", "Passt Super"]
    
    @djs = DiscJockey::DBManager::User.find(:all, :conditions => [ "role = ?", "dj"])
    @djs_match = []
    @djs.each do |dj|
      if dj.aka_dj_name.nil? then dj.aka_dj_name = dj.name end
      # FIXME: random scoring!!! Make a lib for that task
      favour = dj.wishes.first
      score = 0

      idx = favour.background_musik.index(@wish.background_musik)
      # Wenn der Hintergrundwunsch in den Angeboten des DJ gefunden wird der Index im 
      # String zurückgegeben. Mit dem kann der Substring per regeulären Ausdruck danach 
      # untersucht werden, wie gut das Angebot vom DJ ist. 
      # z.B.
      # @wish.background_musik = "Cafe del Mar"
      # @favour.background_musik = "Bar Jazz: Mittel;Cafe del Mar: Viel;Chanson: Nix;Klassik: Nix;Kuba: Mittel;Lounge: Mittel;Aktuelles: Viel"
      # --> idx = 17
      # favour.background_musik[idx..-1][/^([\w\s]+:)\s*([\w\s]+)/] --> "Viel"
      # $2 steht für den Treffer in der zweiten Klammer, also ist 
      # how_much.index($2) --> 2
      unless idx.nil?
        favour.background_musik[idx..-1][/^([\w\s\/-]+:)\s*([\w\s]+)/]
        score = score + how_much.index($2)
      end



      wish_genre = @wish.tanzmusik_genre.split(";").map {|i| i.split(":")}
      
      wish_genre.each do |w|
        idx = favour.tanzmusik_genre.index(w[0])
        unless idx.nil?
          favour.tanzmusik_genre[idx..-1][/^([öä\w\s\/-]+:)\s*([\w\s]+)/]
          score = score + 2 - (how_much.index($2) - like_it.index(w[1].strip)).abs
        end
      end
      
      @djs_match << DJScore.new(dj.aka_dj_name, score)

    end
    @djs_match.sort! {|x,y| x.score <=> y.score}.reverse!
    @max_score = @djs_match.max { |x,y| x.score <=> y.score}
    erb = ERB.new(File.read("web/views/email.html.erb"))
    body_html =  erb.result(binding)
    # END: In lib auslagern

    mailer_config = YAML.load_file(File.join('config','email.yml'))

    Pony.options = {
      :via =>  mailer_config["via"],
      :address => mailer_config["address"],
      :port => mailer_config["port"],
      :enable_starttls_auto => mailer_config["enable_starttls_auto"],
      :user_name => mailer_config["user_name"],
      :password => mailer_config["password"],
      :authentication => mailer_config["authentication"],
      :domain => mailer_config["domain"]
    }

    Pony.mail(:to => mailer_config["to"], 
      :cc => mailer_config["cc"], 
      :from => mailer_config["from"],
      :subject => "WishMeMusic Event Report", 
      :content_type => "text/html",
      :body => body_html)

    haml :abschluss
  end

  get '/admin' do
    haml :admin
  end
end