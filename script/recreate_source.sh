#!/bin/bash

bundle --without production

cd config

for f in scheme_description*.yml 
do
	bundle exec rake db:create_migration_file[\'${f}\']
done

cd ..

bundle exec rake db:migrate

#bundle exec rake db:load_djs	