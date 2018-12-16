# frozen_string_literal: true

desc 'Run rake db:seed if ENV_TYPE is not "sidekiq"'
task conditional_db_seed: :environment do
  if ENV['ENV_TYPE'] != 'sidekiq'
    puts "Running rake db:seed since ENV_TYPE was: '#{ENV['ENV_TYPE']}' which is not equal to 'sidekiq'"
    Rake::Task['db:seed'].execute
  end
end
