source 'http://rubygems.org'

gem 'rails', '4.0.0'
gem 'rack', '~> 1.5.2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '4.0.0'
  gem 'coffee-rails', '4.0.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby
end

group :test, :development do
# Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :production do
  gem 'mysql2'
end

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

# This version needs to be hardcoded for OpenShift compatibility
gem 'thor', '0.18.1'
gem 'devise', '3.0.0.rc'
# This needs to be installed so we can run Rails console on OpenShift directly
gem 'minitest'

group :test do
  if RUBY_PLATFORM =~ /(win32|w32)/
      gem "win32console", '1.3.0'
  end
  gem "minitest-reporters", '>= 0.5.0'
end