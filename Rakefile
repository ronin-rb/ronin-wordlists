# frozen_string_literal: true
require 'rubygems'

begin
  require 'bundler'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler"
  exit(-1)
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

require 'rubygems/tasks'
Gem::Tasks.new(sign: {checksum: true, pgp: true})

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :test    => :spec
task :default => :test

namespace :lint do
  desc "Lint data/wordlists.yml"
  RSpec::Core::RakeTask.new(:wordlists) do |t|
    t.pattern    = 'lint/wordlists_yml_spec.rb'
    t.rspec_opts = ['--format', 'progress']
  end
end
task :lint => 'lint:wordlists'

require 'yard'
YARD::Rake::YardocTask.new
task :docs => :yard

require 'kramdown/man/task'
Kramdown::Man::Task.new

require 'command_kit/completion/task'
CommandKit::Completion::Task.new(
  class_file:  'ronin/wordlists/cli',
  class_name:  'Ronin::Wordlists::CLI',
  input_file:  'data/completions/ronin-wordlists.yml',
  output_file: 'data/completions/ronin-wordlists'
)

task :setup => %w[man command_kit:completion]
