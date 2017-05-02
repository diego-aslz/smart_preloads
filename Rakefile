# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification...
  # see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = 'smart_includes'
  gem.homepage = 'http://github.com/nerde/smart_includes'
  gem.license = 'MIT'
  gem.summary = 'Smart association loading for ActiveRecord.'
  gem.description = 'Avoid N + 1 queries without having to worry about it at all!'
  gem.email = 'diegoselzlein@gmail.com'
  gem.authors = ['Diego Aguir Selzlein']
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc 'Code coverage detail'
task :simplecov do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end

task default: :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "smart_includes #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
