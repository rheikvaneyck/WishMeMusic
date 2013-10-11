require 'bundler/setup'
require 'haml'
require 'erb'
require 'pony'
require 'time'
require 'disc_jockey'

Dir[File.join(File.dirname(__FILE__), '..', 'models', '*.rb')].each do |file| 
  require file 
end

class DiscJockeyController < ApplicationController

  include DiscJockey

  get '/' do
    haml :start
  end

  get '/hintergrund' do  
    @hintergr = ['Bar Jazz','Cafe del Mar', 'Chanson', 'Klassik', 'Kuba', 'Lounge', 'Aktuelles']
    puts @hintergr[0]
    @descriptions = {
      @hintergr[0] => "Bar Jazz ist...",
      @hintergr[1] => "Cafe del Mar ist...",
      @hintergr[2] => "Chanson ist...",
      @hintergr[3] => "Klassik ist...",
      @hintergr[4] => "Kuba ist...",
      @hintergr[5] => "Lounge ist...",
      @hintergr[6] => "Aktuelles ist..."
    }

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
    @categories = ["Passt Super", "Geht so", "Ist Ok", "Lieber nicht"]
    @times = ['20/30/40er Jahre', '50/60er Jahre', '70er Jahre', '80er Jahre', '90er Jahre', '2000 bis heute']
    haml :tanzmusik_zeit
  end

  post '/tanzmusik_zeit' do
    @categories = ["Passt Super", "Geht so", "Ist Ok", "Lieber nicht"]
    @times = ['20/30/40er Jahre', '50/60er Jahre', '70er Jahre', '80er Jahre', '90er Jahre', '2000 bis heute']
    str = []
    params.each do |key, value|
      str << "#{key}: #{value}" if @times.include?(key) and @categories.include?(value)
    end
    session[:tanzmusik_zeit] = str.join(";")
    redirect '/tanzmusik_genre'
  end

  get '/tanzmusik_genre' do
    @categories = ["Passt Super", "Geht so", "Ist Ok", "Lieber nicht"]
    @genres = ['Aktuelle Charts', 'POP International', 'POP Deutsch', 'Rock Oldies', 'Rock Modern', 'Rock Deutsch', 'Alternative', 'Soul/Funk', 'Latino', 'House/Techno', 'Hip Hop International', 'Hip Hop Deutsch','World-Musik', 'Kölsches Tön', 'Schlager/NDW', 'Mallorca/Apres-Ski', 'Standard-Tänze']     
    haml :tanzmusik_genre
  end

  post '/tanzmusik_genre' do
    @categories = ["Passt Super", "Geht so", "Ist Ok", "Lieber nicht"]
    @genres = ['Aktuelle Charts', 'POP International', 'POP Deutsch', 'Rock Oldies', 'Rock Modern', 'Rock Deutsch', 'Alternative', 'Soul/Funk', 'Latino', 'House/Techno', 'Hip Hop International', 'Hip Hop Deutsch','World-Musik', 'Kölsches Tön', 'Schlager/NDW', 'Mallorca/Apres-Ski', 'Standard-Tänze']     
    str = []
    params.each do |key, value|
      str << "#{key}: #{value}" if @genres.include?(key) and @categories.include?(value)
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
    @db = DBManager.new
    # Get the parameters for further parsing
    name = params[:name]
    email = params[:email]
    tel = params[:tel]
    datum = params[:datum]
    zeit = params[:zeit]
    strasse = params[:strasse]
    stadt = params[:stadt]
    anzahl = params[:anzahl]
    anzahl20 = params[:unter20]
    anzahl60 = params[:ueber60]
    equipment = params[:equipment]
    beratung = params[:beratung]
    kommentar = params[:message] 

    hardening = :medium

    case hardening 
    when :secure
      name = params[:name].filter_purpose(:name)
      email = params[:email].filter_purpose(:email)
      tel = params[:tel].filter_purpose(:tel)
      datum = params[:datum].filter_purpose(:datum)
      zeit = params[:zeit].filter_purpose(:zeit)
      strasse = params[:strasse].filter_purpose(:street)
      stadt = params[:stadt].filter_purpose(:city)
      anzahl = params[:anzahl].filter_purpose(:numbers)
      anzahl20 = params[:unter20].filter_purpose(:numbers)
      anzahl60 = params[:ueber60].filter_purpose(:numbers)
      equipment = params[:equipment].filter_purpose(:word)
      beratung = params[:beratung].filter_purpose(:word)
      # Here is a vulnerability:
      kommentar = CGI::escape_html(params[:message])
    when :medium
      name = CGI::escape_html(params[:name])
      email = CGI::escape_html(params[:email])
      tel = CGI::escape_html(paramsCGI::escape_html([:tel])
      datum = CGI::escape_html(params[:datum])
      zeit = CGI::escape_html(params[:zeit])
      strasse = CGI::escape_html(params[:strasse])
      stadt = CGI::escape_html(params[:stadt])
      anzahl = CGI::escape_html(params[:anzahl])
      anzahl20 = CGI::escape_html(params[:unter20])
      anzahl60 = CGI::escape_html(params[:ueber60])
      equipment = CGI::escape_html(params[:equipment])
      beratung = CGI::escape_html(params[:beratung])
      kommentar = CGI::escape_html(params[:message])
    end      
    
    surname = (params[:name]).split(" ") unless params[:name].nil?
    lastname = surname.last unless surname.nil?
    surname.delete(lastname) unless lastname.nil?
    surname = surname.join(" ")

    @u = User.find(:first, :conditions => [ "email = ?", params[:email]])
    
    @u = User.create(
      :name => lastname,
      :firstname => surname,
      :email  => params[:email],
      :tel => params[:tel],
      :role => 'user') if @u.nil?

    @w = Wish.create(
      :background_musik => session[:hintergrund], 
      :tanzmusik_genre => session[:tanzmusik_genre], 
      :tanzmusik_zeit => session[:tanzmusik_zeit], 
      :user_id => @u.id)

    @er = Event.new do |r|
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

    @db = DBManager.new
    @event = Event.find(@id)
    @user = User.find(@event.user_id)
    @wish = Wish.find(@event.wish_id)

    @event_date = Time.parse(@event.datum.to_s).strftime("%d. %b %Y") unless @event.datum.nil?
    @event_time = Time.parse(@event.zeit.to_s).strftime("%H:%M") unless @event.zeit.nil?

    # FIXME: Lege die Kategorien in der DB oder config ab!
    @djs = User.find(:all, :conditions => [ "role = ?", "dj"])

    @ms = MatchScore.new(@wish, @djs)

    dj_scale = ["NoGo", "Nix", "Mittel", "Viel"]
    wish_scale = ["Lieber nicht", "Geht so", "Ist OK", "Passt Super"]

    @ms.score(wish_scale, dj_scale)

    erb = ERB.new(File.read("web/views/email.html.erb"))
    body_html =  erb.result(binding)

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