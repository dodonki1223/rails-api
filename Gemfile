source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use Puma as the app server
gem 'puma', '~> 4.3'
gem 'rspec-rails'
gem 'factory_bot_rails'

# Github:   https://github.com/rails-api/active_model_serializers
# Document: https://github.com/rails-api/active_model_serializers/tree/v0.10.6/docs
#   railsでjson出力というと、rabl、後はrails4からデフォルトになったjbuilderがあるが、
#   これらはどちらもテンプレートエンジンで、オブジェクト指向的な書き方が出来なかった.
#   対して、active_model_serializersは、テンプレートエンジンではなく、出力内容をserializerというクラスに定義するため、
#   オブジェクト指向的な書き方が出来る、というものらしい
gem 'active_model_serializers'

# active_model_serializers と機能は一緒だが、メンテナンスがされていないので Netflex がメンテナンスをしている
# fast_jsonapi に変更したほうが良さそうなので乗り換える
# Github: https://github.com/Netflix/fast_jsonapi
gem 'fast_jsonapi'

gem 'kaminari'
gem 'octokit', "~> 4.0"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :production do
  gem 'pg' #postgres db required by heroku by default
end

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '~> 1.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
