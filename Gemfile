source "https://rubygems.org"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#

# Use modern Jekyll version compatible with Ruby 3.4+
gem 'jekyll', '~> 4.3'
# Force older jekyll-sass-converter that uses sass instead of sass-embedded
gem 'jekyll-sass-converter', '~> 2.0'
# Use sass instead of sass-embedded to avoid google-protobuf dependency
gem 'sass', '~> 3.7'
gem 'wdm', '>= 0.1.0' if Gem.win_platform?

# Required for Ruby 3.0+ (rexml was removed from standard library)
gem 'rexml'
# Required for Ruby 3.4.0+ (csv and bigdecimal were removed from default gems)
gem 'csv'
gem 'bigdecimal'
# Required for Ruby 3.5.0+ (logger will be removed from default gems)
gem 'logger'

group :jekyll_plugins do
    gem 'jekyll-feed', '~> 0.17'
    gem 'jekyll-sitemap', '~> 1.4'
    gem 'jekyll-paginate', '~> 1.1'
    gem 'jekyll-seo-tag', '~> 2.8'
    gem 'jekyll-archives', '~> 2.2'
    gem 'kramdown', '~> 2.4'
    gem 'rouge', '~> 4.2'
end
