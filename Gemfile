source "https://rubygems.org"

# Load Ruby 3.4+ compatibility patch before Jekyll loads
# This fixes the tainted? method issue with Liquid 4.0.3
require_relative 'ruby34_patch' if File.exist?(File.join(__dir__, 'ruby34_patch.rb'))

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#

# Use github-pages gem which manages Jekyll and plugin versions
# Upgraded to support Ruby 3.4+
gem 'github-pages', group: :jekyll_plugins
gem 'wdm', '>= 0.1.0' if Gem.win_platform?

# Required for Ruby 3.0+ (rexml was removed from standard library)
gem 'rexml'
# Required for Ruby 3.4.0+ (csv and bigdecimal were removed from default gems)
gem 'csv'
gem 'bigdecimal'
# Required for Ruby 3.5.0+ (logger will be removed from default gems)
gem 'logger'
# Required for Ruby 3.4+ (webrick was removed from standard library, needed for jekyll serve)
gem 'webrick'

group :jekyll_plugins do
    # github-pages includes jekyll-feed, jekyll-sitemap, jekyll-paginate, jekyll-seo-tag
    # Only specify plugins not included in github-pages
    gem 'jekyll-archives', '~> 2.2'
end
