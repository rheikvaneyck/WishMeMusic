require 'active_record'
require 'uri'
require 'yaml'
require 'logger'
require 'rake'

task :default => "orga:show_todos"

namespace :orga do
  desc "ToDos"
  task :show_todos do
    puts File.read('TODOS.TXT')
  end
  desc "Clean-up"
  task :clean_up do
    Dir.glob('**/*.*~').each do|f|
      puts "delete #{f}"
      File.delete(f)
    end
  end
end

namespace :db do
  desc "Create the initial migration file"
  task :create_migration_file, :filename do |t, args|
      abort("Run 'rake db:create_migration_file['scheme description yml file']' with that file in the config/ directory") if args[:filename].nil?
      ruby "script/create_scheme/create_migration.rb #{args[:filename]}"
  end 

  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  end

  task :environment do
    if (ENV['DATABASE_URL']) then
      db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/app-dev')
      db_config = {
        :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
        :host     => db.host,
        :port     => db.port,
        :username => db.user,
        :password => db.password,
        :database => db.path[1..-1],
        :encoding => 'utf8',
      }
    elsif (ENV['PRODUCTION']) then
      db_config = YAML::load(File.open(File.join('config','database.yml')))['production']
      ActiveRecord::Base.logger = Logger.new(File.open(File.join('log','database.log'), 'a'))
    else
      db_config = YAML::load(File.open(File.join('config','database.yml')))['development']
      ActiveRecord::Base.logger = Logger.new(File.open(File.join('log','database.log'), 'a'))
    end
    ActiveRecord::Base.establish_connection(db_config)
  end 
end  

namespace :web do
  desc "Run the sinatra app"
  task :run do
    # ruby "-Ilib web/run_weather_dash.rb"
    system("bundle exec rackup -Ilib -s thin -p 4567 -E development -P log/rack.pid web/config.ru")
  end
end

namespace :test do
  begin
    require 'rspec/core/rake_task'
    
    desc "run all specs" 
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.pattern =  'spec/*_spec.rb'
    end
  rescue LoadError
  end  
end
