require 'bundler/setup'
require 'haml'
require 'pony'
require 'time'
require 'disc_jockey'

class DiscJockeyController < ApplicationController

  get '/' do
    haml :start
  end

  get '/hintergrund' do  
    @hintergr = ['Cafe del Mar', 'Lounge', 'Chillout']
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

    @event_date = Time.parse(@event.datum.to_s).strftime("%d. %b %Y")
    @event_time = Time.parse(@event.zeit.to_s).strftime("%H:%M")

    body_text = <<-END

    Event-ID: #{@event.id}
    Kunde: #{@user.firstname} #{@user.name}

    Event am: #{@event_date} um #{@event_time} Uhr
    
    Hintergrund-Musik: 
      #{@wish.background_musik.split(";").join("\t\n")}

    Tanzmusik Genre: 
      #{@wish.tanzmusik_genre.split(";").join("\t\n")}
    
    Tanzmusik Zeit: 
      #{@wish.tanzmusik_zeit.split(";").join("\t\n")}

    Kontakt: #{@user.email}
    END

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

    Pony.mail(:to => mailer_config["to"], :cc => mailer_config["cc"], :subject => "WishMeMusic Event Report", :body => "#{body_text}")

    haml :abschluss
  end

  get '/admin' do
    haml :admin
  end
end