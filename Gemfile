source 'https://rubygems.org'

gem "rspec", "~>3"
gem "rspec-legacy_formatters", "~>1"
gem 'origen', '>= 0.59.8'

# Specify your gem's dependencies in memory_image.gemspec
gemspec

gem 'coveralls', require: false

if RUBY_VERSION >= '2.5.0'
  gem "byebug", "~>10"
elsif RUBY_VERSION >= '2.0.0'
  gem 'byebug', '~>3.5'
else
  gem 'debugger', '~>1.6'
end
