source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.9'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# MongoDB
gem 'bson_ext'
gem 'mongoid', '~> 4.0', '>= 4.0.2'

# Redis
gem 'redis', '~> 4.0', '>= 4.0.1'
gem 'redis-namespace'
gem 'redis-rails'

# Sidekiq
gem 'sidekiq', '~> 5.0', '>= 5.0.5'

# ElasticSearch
gem 'elasticsearch-model', github: 'elastic/elasticsearch-rails', branch: '5.x'
gem 'elasticsearch-persistence', github: 'elastic/elasticsearch-rails', branch: '5.x'
gem 'elasticsearch-rails', github: 'elastic/elasticsearch-rails', branch: '5.x'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry-byebug', '~> 3.4'

  # Rspec
  gem 'rspec-rails', '~> 3.7'

  # Factory Girl
  gem 'factory_girl_rails', '~> 4.0'

  # Test coverage
  gem 'simplecov', '~> 0.16.1'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Rubocop
  gem 'rubocop', require: false
end

group :test do
  #RSpec Sidekiq
  gem 'rspec-sidekiq'
end
