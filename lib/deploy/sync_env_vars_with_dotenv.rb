#!/usr/bin/env ruby
require 'yaml'
require 'active_support/core_ext/object/blank'

class SyncEnvVarsWithDotenv
  def self.sync(file_name, env_vars = nil)
    puts "Reading file: #{file_name}"
    yaml = YAML.load_file(file_name)
    unless yaml
      puts "The file: #{file_name} appears to be empty. Attempting to populate from the current ENV variables."
      yaml = {}
    end

    if env_vars.blank?
      puts 'The list of environment variables passed in was empty. Using default list.'
      env_vars = %w(RDS_DB_NAME RDS_USERNAME RDS_PASSWORD RDS_HOSTNAME RDS_PORT)
    end

    env_vars.each do |env_var|
      puts "Working on var: #{env_var}"
      if yaml[env_var].nil?
        puts "Var: #{env_var} was not in: #{file_name}"
        live_env = ENV[env_var]
        if live_env
          puts "Setting #{env_var} to #{live_env}"
          yaml[env_var] = live_env
        else
          puts "The value for: #{env_var} was empty in the file: #{file_name} and the local ENV. Not setting."
        end
      end
    end

    File.open(file_name, 'w') { |f| f.write(yaml.to_yaml) }
    puts "Wrote out: #{file_name}\n\n"
  end
end

if __FILE__ == $0
  ARGV.each do |argument|
    if File.directory?(argument)
      puts "\n\nIt looks like a directory was passed in. Will try to inject environment variables found in: #{argument} that end with '.env'"
      absolute_path = File.absolute_path(argument)
      Dir.glob(absolute_path + '/*.env').each do |arg|
        SyncEnvVarsWithDotenv.sync(arg)
      end
    elsif File.exists?(argument)
      SyncEnvVarsWithDotenv.sync(argument)
    else
      puts "Could not find file: \"#{argument}\". Is it reachable from: \"#{Dir.pwd}\"?"
    end

  end
end