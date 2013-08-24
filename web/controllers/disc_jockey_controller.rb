require 'bundler/setup'
require 'haml'
# require 'pony'
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
     redirect '/tanzmusik_zeit'
  end

  get '/tanzmusik_zeit' do
    @times = ['20/30/40er Jahre', '50/60er Jahre', '70er Jahre', '70er Jahre', '80er Jahre', '90er Jahre', '2000 bis heute']
    haml :tanzmusik_zeit
  end

  post '/tanzmusik_zeit' do
  	redirect '/tanzmusik_genre'
  end

  get '/tanzmusik_genre' do
     @genres = ['Aktuelle Charts', 'POP International', 'POP Deutsch', 'Rock Oldies', 'Rock Modern', 'Rock Deutsch', 'Alternative', 'Soul/Funk', 'Latino', 'House/Dancecharts/Techno', 'Hip Hop R´n´B International', 'Hip Hop Deutsch','World-Musik', 'Kölsches Tön', 'Schlager/NDW', 'Mallorca/Apres-Ski', 'Standard-Tänze']     
     haml :tanzmusik_genre
  end

  post '/tanzmusik_genre' do
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

    er = DiscJockey::DBManager::EventRequest.new do |r|
      r.Name = params[:name]
      r.Email = params[:email]
      r.Tel = params[:tel]
      r.EventDate = params[:datum]
      r.Start = params[:zeit]
      r.Strasse = params[:strasse]
      r.Ort = params[:stadt]
      r.AnzahlG = params[:anzahl]
      r.AnzahlG20 = params[:unter20]
      r.AnzahlG60 = params[:ueber60]
      r.EquipExist = params[:equipment]
      r.TechConsult = params[:beratung]
      r.Kommentar = params[:message]
    end
    er.save

    redirect '/abschluss'
  end
    
  get '/abschluss' do
    haml :abschluss
  end

  get '/admin' do
    haml :admin
  end
end