# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('config/application', __dir__)

Rails.application.load_tasks

task default: %i[rubocop test]

# desc 'Run tests'
# task :test do
#   rake test
# end

desc 'Run rubocop'
task :rubocop do
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
end
