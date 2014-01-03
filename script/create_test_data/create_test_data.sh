#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )" 
DB="test_data.sqlite3"

echo $DIR 

function error_quit {
  echo $1
  exit
}

pushd .
cd $DIR

[ -f users.sql ] || error_quit "No users.sql file in ${DIR}"

sqlite3 ${DB} '.read users.sql'
sqlite3 ${DB} 'select * from users;'

[ -f wishes.sql ] || error_quit "No wishes.sql file in ${DIR}" 

sqlite3 ${DB} '.read wishes.sql'
sqlite3 ${DB} 'select * from wishes;'

[ -f events.sql ] || error_quit "No events.sql file in ${DIR}" 

sqlite3 ${DB} '.read events.sql'
sqlite3 ${DB} 'select * from events;'

[ -f ${DB} ] && echo "test db successfully created"

popd