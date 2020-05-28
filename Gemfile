source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.1'

gem 'mysql2', '~> 0.5.2'

# Use Puma as the app server
gem 'puma', '~> 4.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'dotenv-rails'
  gem 'awesome_print'

  # gem 'annotate', git: 'https://github.com/ctran/annotate_models.git'
  gem 'annotate', '~> 2.7.5'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# http request
gem 'faraday', '~> 0.14.0'

gem 'awesome_print'

gem 'jbuilder', '~> 2.5'

# background job
gem 'sidekiq', '~> 5.2.7'
gem 'sidekiq-cron', '~> 1.1.0'
gem 'rufus-scheduler', '~> 3.6.0'

gem "hiredis", "~> 0.6.3"
gem 'redis', '~> 4.0', :require => ["redis", "redis/connection/hiredis"]
gem 'redis-namespace', '~> 1.6'
# gem 'redis-rails'

gem 'jwt', '~> 2.2', '>= 2.2.1'

gem 'rack-attack', '~> 5.0'
gem 'rack-cors', require: 'rack/cors'

# pagenation
gem 'kaminari', '~> 1.2.1'

gem 'goldiloader', '~> 3.1', '>= 3.1.1'
gem 'oj', '~> 3.9', '>= 3.9.2'

gem 'acts_as_paranoid', '~> 0.6.1'

# map
gem 'geocoder'

# # gem 'geoip'
# gem 'maxminddb', '~> 0.1.22'

# # photo uploader
# gem 'carrierwave', '~> 2.0'
# gem "fog-aws"

gem 'aws-sdk', '~> 3'

# pdf to jpg
gem 'rmagick'
# gem "mini_magick"

