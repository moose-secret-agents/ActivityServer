# ActivityServer
The Activity-tracking Server application for Sweat-to-Score

Installation instructions:

* Install Ruby 2.1.3: [Ruby Installation Guide](https://www.ruby-lang.org/en/documentation/installation/)
* Install PostgreSQL: [Postgres Installation Guide](http://www.postgresql.org/download/)
* Clone the Project: [GitHub Repository](https://github.com/moose-secret-agents/ActivityServer)
* Go to your Terminal and perform the following actions from the application root folder:
    * `$ gem install bundler`
    * `$ bundle install`
    * `$ rake db:create db:migrate`
    * `$ rake db:seed`
    * `$ rails s`
