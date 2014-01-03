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
    @hintergr = Music.find(:all, :conditions => [ "category = ?", 'hintergrund']
  
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
    @categories = Category.find(:all, :conditions => [ "category = ?", 'wish']
    @times = Music.find(:all, :conditions => [ "category = ?", 'zeit']
    
    haml :tanzmusik_zeit
  end

  post '/tanzmusik_zeit' do
    @categories = Category.find(:all, :conditions => [ "category = ?", 'wish']
    @times = Music.find(:all, :conditions => [ "category = ?", 'zeit']
    str = []
    params.each do |key, value|
      str << "#{key}: #{value}" if collection_item_prop_include?(@times, :category, key) and collection_item_prop_include?(@categories, :value, value)
    end
    session[:tanzmusik_zeit] = str.join(";")
    redirect '/tanzmusik_genre'
  end

  get '/tanzmusik_genre' do
    @categories = Category.find(:all, :conditions => [ "category = ?", 'wish']
    @genres =  Music.find(:all, :conditions => [ "category = ?", 'genre']
       
    haml :tanzmusik_genre
  end

  post '/tanzmusik_genre' do
    @categories = Category.find(:all, :conditions => [ "category = ?", 'wish']
    @genres =  Music.find(:all, :conditions => [ "category = ?", 'genre']
    str = []
    params.each do |key, value|
      str << "#{key}: #{value}" if collection_item_prop_include?(@genres, :category, key) and collection_item_prop_include?(@categories, :value, value)
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

    redirect '/' unless params[:plz].empty?
    logger.info Dir.pwd
    @db = DBManager.new
    # deklare with empty strings
    name = ""
    email = ""
    tel = ""
    datum = ""
    zeit = ""
    ort = ""
    strasse = ""
    stadt = ""
    anzahl = ""
    anzahl20 = ""
    anzahl60 = ""
    equipment = ""
    beratung = ""
    kommentar = ""

    # FIXME: Set hardening level per environment in config or as an option
    hardening = :medium

    case hardening 
    when :secure
      name = params[:name].filter_purpose(:name) unless params[:name].nil?
      email = params[:email].filter_purpose(:email) unless params[:email].nil?
      tel = params[:tel].filter_purpose(:tel) unless params[:tel].nil?
      datum = params[:datum].filter_purpose(:datum) unless params[:datum].nil?
      zeit = params[:zeit].filter_purpose(:zeit) unless params[:zeit].nil?
      ort = params[:ort].filter_purpose(:ort) unless params[:ort].nil?
      strasse = params[:strasse].filter_purpose(:street) unless params[:strasse].nil?
      stadt = params[:stadt].filter_purpose(:city) unless params[:stadt].nil?
      anzahl = params[:anzahl].filter_purpose(:numbers) unless params[:anzahl].nil?
      anzahl20 = params[:unter20].filter_purpose(:numbers) unless params[:unter20].nil?
      anzahl60 = params[:ueber60].filter_purpose(:numbers) unless params[:ueber60].nil?
      equipment = params[:equipment].filter_purpose(:word) unless params[:equipment].nil?
      beratung = params[:beratung].filter_purpose(:word) unless params[:beratung].nil?
      # Here is a vulnerability:
      kommentar = CGI::escape_html(params[:message]) unless params[:beratung].nil?
    when :medium
      name = CGI::escape_html(params[:name]) unless params[:name].nil?
      email = CGI::escape_html(params[:email]) unless params[:email].nil?
      tel = CGI::escape_html(params[:tel]) unless params[:tel].nil?
      datum = CGI::escape_html(params[:datum]) unless params[:datum].nil?
      zeit = CGI::escape_html(params[:zeit]) unless params[:zeit].nil?
      ort = CGI::escape_html(params[:ort]) unless params[:ort].nil?
      strasse = CGI::escape_html(params[:strasse]) unless params[:strasse].nil?
      stadt = CGI::escape_html(params[:stadt]) unless params[:stadt].nil?
      anzahl = CGI::escape_html(params[:anzahl]) unless params[:anzahl].nil?
      anzahl20 = CGI::escape_html(params[:unter20]) unless params[:unter20].nil?
      anzahl60 = CGI::escape_html(params[:ueber60]) unless params[:ueber60].nil?
      equipment = CGI::escape_html(params[:equipment]) unless params[:equipment].nil?
      beratung = CGI::escape_html(params[:beratung]) unless params[:beratung].nil?
      kommentar = CGI::escape_html(params[:message]) unless params[:message].nil?
    end      
    
    surname = (name).split(" ")
    lastname = surname.last.nil? ? "" : surname.last 
    surname.delete(lastname) unless lastname.empty?
    surname = surname.join(" ")

    @u = User.find(:first, :conditions => [ "email = ?", email])
    
    @u = User.create(
      :name => lastname,
      :firstname => surname,
      :email  => email,
      :tel => tel,
      :role => 'user') if @u.nil?

    @w = Wish.create(
      :background_musik => session[:hintergrund], 
      :tanzmusik_genre => session[:tanzmusik_genre], 
      :tanzmusik_zeit => session[:tanzmusik_zeit], 
      :user_id => @u.id)

    @er = Event.new do |r|
      r.datum = datum
      r.zeit = zeit
      r.ort = ort
      r.strasse = strasse
      r.stadt = stadt
      r.anzahl = anzahl
      r.anzahl20 = anzahl20
      r.anzahl60 = anzahl60
      r.equipment = equipment
      r.beratung = beratung
      r.kommentar = kommentar
      r.user_id = @u.id
      r.wish_id = @w.id
    end
    @er.save
    
    session[:event_id] = @er.id

    redirect "/confirm"
  end

  get '/confirm' do
    @id = session[:event_id]

    unless @id.nil? then
      @db = DBManager.new
      @event = Event.find(@id)
      unless @event.nil? then
        @user = User.find(@event.user_id)
        @wish = Wish.find(@event.wish_id)

        @event_date = Time.parse(@event.datum.to_s).strftime("%d. %b %Y") unless @event.datum.nil?
        @event_time = Time.parse(@event.zeit.to_s).strftime("%H:%M") unless @event.zeit.nil?
      end
    end

    haml :confirm
  end

  post '/confirm' do
    redirect '/abschluss'
  end

  post '/cancel' do
    @id = session[:event_id]

    unless @id.nil? then
      @db = DBManager.new

      @event = Event.find(@id)

      unless @event.nil? then
        @user = User.find(@event.user_id)

        Wish.destroy(@event.wish_id)
        Event.destroy(@id)
        User.destroy(@user.id) if @user.events.empty?

        logger.info "event #{@id}: #{@user.name} ge-cancelt und gelöscht"
      end
    end

    #FIXME: Hinweis, dass abgebrochen wurde
    redirect '/'
  end
    
  get '/abschluss' do
    @id = session[:event_id]

    if @id.nil? then 
      #FIXME: Hinweis, dass das Event nicht gefunden wurde 
      redirect '/'
    end
    
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
    wish_scale = ["Gar nicht", "Wenig", "Mittel", "Viel"]

    @ms.score(wish_scale, dj_scale)

    erb = ERB.new(File.read(File.expand_path('../../views/email.html.erb', __FILE__)))
    body_html =  erb.result(binding)

    mailer_config = YAML.load_file(File.join(File.expand_path('../../config', __FILE__),'email.yml'))

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
