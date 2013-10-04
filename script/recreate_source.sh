#!/bin/bash
case "$1" in 
	"production")
		GROUP="production" ;;
 	"development")
		GROUP="development" ;;
	"test")
		GROUP="development" ;;
	*)
		GROUP="development" ;;
esac

bundle --without $GROUP

cd config

for f in scheme_description*.yml 
do
	bundle exec rake db:create_migration_file[\'${f}\']
done

cd ..

bundle exec rake db:migrate

bundle exec rake db:load_djs	