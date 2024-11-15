source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.2'
# Use postgresql as the database for Active Record
gem "pg" # , "~> 1.1"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use SCSS for stylesheets
#gem 'sass-rails' # , '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
#gem 'uglifier' # , '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
#gem 'coffee-rails' # , '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
#gem 'turbolinks' # , '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'


gem 'active_model_serializers'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap' #, '>= 1.1.0', require: false

# Depricated gems
# ruby 3.5
gem 'ostruct'

# Use jquery as the JavaScript library
# gem 'jquery-rails'

# HAML is my preferred template language
gem 'haml-rails'

# I like Bootstrap
gem 'simple_form'
gem 'bootstrap' #, '~> 4'

# Protect the app with Devise
gem 'devise'

# Even production DB will be seeded with faked data
gem 'faker'

# Call Rails API application
gem 'httparty'

# Enable i18n based on request header
gem 'http_accept_language'

# Pagination
gem 'kaminari'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Testing with RSpec
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'

  # Better console
  gem 'pry-rails'
  gem 'pry-rescue'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console' #, '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Used to generate a standard layout for Bootstrap frontend
  #gem 'rails_layout'

  # I always make errors :-)
  gem 'better_errors'
  gem 'binding_of_caller'

  # I love HAML
  gem 'html2haml'
end

group :test do
  # Everything you need for your Integration tests
  gem 'capybara'
  gem 'selenium-webdriver'

  gem 'database_cleaner'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
