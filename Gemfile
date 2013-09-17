source 'https://rubygems.org'
gem 'json'
gem 'netrc'
gem 'highline'
gem 'eventmachine'
gem 'em-eventsource'

# Specify your gem's dependencies in debox.gemspec
gemspec

group :test do
  gem 'debox_server'
  gem 'rspec'
  gem 'thin' # We need it for eventsource
  gem 'database_cleaner'
  gem 'mysql2'
end
