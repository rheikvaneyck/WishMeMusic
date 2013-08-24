WishMe Music
======

Web based Wish-A-DJ Form  

**Currently under development**

lola is a small web based dashboard using Ruby's sinatra library as application middleware. 

Dependencies
------------

###Libraries

Install the following libs beforehead (packet names for Fedora 18):
* postgresql-devel (for production environment)
* sqlite-devel
* readline-devel
* openssl-devel
* zlib-devel


###Install all the gems we need

1. install the bundler gem >> `gem install bundler`

The Ruby gems used are listed in the Gemfile. You can use the bundler gem to install them automaticly. If you have the **bundler** installed the next step after downloading the source is a call of `bundle install` in the source directory.

2. install the gems by `bundle install`

The gems the app needs depend on the application environment. During Development and testing the productiv gems aren't needed. So install only the development gems with `bundle --without production`. Thus, the app depends on sqlite3 and will use this local database file. 

FIXME: From here the rest is up to development:

Download the application
------------------------

Let's Make a local copy of the source tree of the application with git:

```
git clone git://github.com/rheikvaneyck/lola.git
```

Prepare the application
-----------------------

###Create the migration file

Before we can use a database we have to describe the database scheme. This is the base to run a migration in the next step. Usally this is part of the development process. But to make it easyer there is a script for it. Just edit the scheme_description*.yml files or create one and run 

```
rake db:create_migration_file
``` 

###Create the database

Now we have to import the data in the database. But first we need one. You create that database and the necessary tables with ruby's **rake** tool:

```
rake db:migrate
```

All available rake tasks can be shown with the `rake -T` command.

###Import the data manually

Then you can import the data into the database with a rake task:
```
rake db:load_data
```

###Run the application

The application can be started with `rake web:run`. The web application listens on http://localhost:4567/

License
-------

(The GPL)

Copyright (c) 2013 Viktor Rzesanke

lola is copyrighted free software by Viktor Rzesanke.
You can redistribute it and/or modify it under either the terms of the GPL
(see COPYING.txt file).

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
