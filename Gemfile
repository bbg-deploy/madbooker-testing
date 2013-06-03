# http://www.a.rnaud.net/2011/10/how-to-fix-invalid-byte-sequence-in-us-ascii-in-bundler-installation/
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source 'http://rubygems.org'

gem 'rails', '4.0.0.rc1'

gem 'rake'
gem 'mysql2'
gem 'colored'
gem 'uuidtools'
gem 'haml'
gem 'riddle', '1.5.1', git: 'git://github.com/stevenbristol/riddle.git', :branch => '1.5.1'
gem 'thinking-sphinx', '2.0.11', require: 'thinking_sphinx'
gem 'ts-delayed-delta', '1.1.3', require: 'thinking_sphinx/deltas/delayed_delta'
gem 'json'
gem 'spectator-attr_encrypted'
gem 'bcrypt-ruby', require: 'bcrypt'
gem 'less-js-routes', :git => "git://github.com/stevenbristol/less-js-routes.git"
gem 'jquery-rails'
gem 'nested_form'
gem 'paperclip'
gem 'nested_has_many_through'
gem 'will_paginate'
gem 'devise'
gem 'simple_form'
gem 'intercom'
gem 'cancan'
gem 'coffee-filter'
gem 'ruby-haml-js'
gem 'memoist'
gem 'thin'
gem 'sass'
#gem 'sass-rails'
gem 'coffee-rails'
gem 'draper'
gem 'less_interactions', '0.0.6', :git => 'git://github.com/LessEverything/less_interactions.git'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'jquery-rails'
  gem 'compass-rails'
  gem 'compass-colors'
  gem 'sassy-buttons'
  gem 'turbo-sprockets-rails3'
end

group :production, :staging do 
  gem 'unicorn'
end

group :development, :staging do
  gem 'meta_request'
  gem 'better_errors'
end


group :development do
  gem 'binding_of_caller'
  gem 'awesome_print'
  gem 'quiet_assets'
  gem 'rails-footnotes'
  #gem 'annotator', '0.0.8.1'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'letter_opener', :git => 'git://github.com/ryanb/letter_opener.git'
end

group :development, :test do
  gem 'qunit-rails'
end

group :test do
  gem 'shoulda'
  gem 'shoulda-context', :git => 'git://github.com/asanghi/shoulda-context.git'
  gem 'mocha'
  gem 'timecop'
  gem 'minitest'
  gem 'fabrication'
  gem 'raindrops'
end

group :debug do
  gem 'debugger'
end
