source 'https://rubygems.org'

gemspec

group :test do
  gem 'ci_reporter_minitest', '~> 1.0.0', require: false
  gem 'minitest', '5.18'
  gem 'minitest-spec-context'
  gem 'mocha'
  gem 'rake', '~> 13.0'
  gem 'simplecov'
  gem 'thor'
end

# load local gemfile
['Gemfile.local.rb', 'Gemfile.local'].map do |file_name|
  local_gemfile = File.join(File.dirname(__FILE__), file_name)
  instance_eval(Bundler.read_file(local_gemfile)) if File.exist?(local_gemfile)
end
