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
  desc "Reset Source"
  task :reset do
    files = %w(db/db.sqlite3 log/database.log bundle/config)
    files.each do |f|
      puts "delete #{f}"
      File.delete(f) if File.exists?(f)
    end
    Dir.glob('.bundle/*').each do|f|
      puts "delete #{f}"
      File.delete(f) if File.exists?(f)
    end
    Dir.rmdir('.bundle') if Dir.exists?('.bundle')
    Dir.glob('db/migrate/*').each do|f|
      puts "delete #{f}"
      File.delete(f) if File.exists?(f)
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

  desc "Load DJs into the database"
  task :load_djs => :environment do
    scheme_description_user = YAML.load_file(File.join('config','scheme_description_user.yml'))
    scheme_description_wish = YAML.load_file(File.join('config','scheme_description_wish.yml'))

    class Wish < ActiveRecord::Base
      belongs_to :users
    end
    class User < ActiveRecord::Base
      has_many :wishes
    end

    Dir.glob('data/user_*.yml').each do |f|
      data = YAML.load_file(f)

      scheme_description_user.each do |key, value|
        scheme_description_user[key] = data[key]
      end
      scheme_description_user[:role] = "dj"

      scheme_description_wish.each do |key, value|
        scheme_description_wish[key] = data[key].map{|k,v| "#{k}: #{v}"}.join(";") unless data[key].nil?
      end


      @u = User.create scheme_description_user
      @u.wishes.create scheme_description_wish

    end
  end
  
  desc "Load categories and descriptions into the database"
  task :load_categories => :environment do
    scheme_description_music = YAML.load_file(File.join('config','scheme_description_music.yml'))
    scheme_description_categories = YAML.load_file(File.join('config','scheme_description_category.yml'))

    class Music < ActiveRecord::Base
    end
    class Category < ActiveRecord::Base
    end

    Dir.glob('data/music.yml').each do |f|
      data = YAML.load_file(f)
      data.each do |d|
        scheme_description_music.each do |key, value|
          scheme_description_music[key] = d[key]
        end
        @m = Music.create scheme_description_music
      end
    end
    
    Dir.glob('data/categories.yml').each do |f|
      data = YAML.load_file(f)
      data.each do |d|
        scheme_description_categories.each do |key, value|
          scheme_description_categories[key] = d[key]
        end
        @c = Category.create scheme_description_categories
      end
    end
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
      Dir.mkdir('log') unless Dir.exists?('log')
      ActiveRecord::Base.logger = Logger.new(File.open(File.join('log','database.log'), 'a'))
    else
      db_config = YAML::load(File.open(File.join('config','database.yml')))['development']
      Dir.mkdir('log') unless Dir.exists?('log')
      ActiveRecord::Base.logger = Logger.new(File.open(File.join('log','database.log'), 'a'))
    end
    ActiveRecord::Base.establish_connection(db_config)
  end 
end  

namespace :web do
  desc "Run the sinatra app"
  task :run do
    # ruby "-Ilib web/run_weather_dash.rb"
    system("bundle exec unicorn -c unicorn.rb -Ilib -E development -D")
  end
  desc "Stop the sinatra app"
  task :stop do
    if File.exists?('tmp/pids/unicorn.pid') then
      @pid = File.read('tmp/pids/unicorn.pid').strip
      if File.exists?("/proc/#{@pid}") then
        Process::kill("SIGINT", @pid.to_i)
      end
    end
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
