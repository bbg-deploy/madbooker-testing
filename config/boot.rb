# Set up gems listed in the Gemfile.
current_path = "/srv/apps/madbooker/current"
ENV['BUNDLE_GEMFILE'] = "#{current_path}/Gemfile"
#ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
