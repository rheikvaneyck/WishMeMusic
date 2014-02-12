class ApplicationController < Sinatra::Base
	helpers ApplicationHelper
	helpers ValidStringHelper
	helpers CollectionHelper

	disable :sessions
	use Rack::Session::Dalli, :cache => Dalli::Client.new

	set :views, File.expand_path('../../views', __FILE__)
  	set :public_folder, File.expand_path('../../public', __FILE__)

	configure :production, :development do
		enable :logging
	end

	not_found do
		title 'Not Found'
		haml :not_found
	end
end
