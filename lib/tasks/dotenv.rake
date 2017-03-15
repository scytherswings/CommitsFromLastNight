desc 'Sync .env file with environment variables'
task :sync_dotenv, [:file_path] => :environment do |_, args|
  SyncEnvVarsWithDotenv.sync(args[:file_path])
end


class SyncEnvVarsWithDotenv
  require 'dotenv/load'

  def self.sync(file_name, env_vars = nil)
    dotenv_file = {}
    if File.exist?(file_name)
      puts "Reading file: #{file_name}"
      dotenv_file = Dotenv.load(file_name)
      unless dotenv_file
        puts "The file: #{file_name} appears to be empty. Attempting to populate from the current ENV variables."
        dotenv_file = {}
      end
    else
      puts "No file named: #{file_name} exists. It will be created probably."
    end

    if env_vars.nil? || env_vars.empty?
      puts 'The list of environment variables passed in was empty. Using default list.'
      env_vars = %w(RDS_DB_NAME RDS_USERNAME RDS_PASSWORD RDS_HOSTNAME RDS_PORT SECRET_KEY_BASE REDIS_STORE_URI SIDEKIQ_REDIS_URI CONFIG_URI SIDEKIQ_PASSWORD BB_USERNAME BB_PASSWORD)
    end

    env_vars.each do |env_var|
      puts "Working on var: #{env_var}"
      if dotenv_file[env_var].nil?
        puts "Var: #{env_var} was not in: #{file_name}"
        live_env = ENV[env_var]
        if live_env
          puts "Setting #{env_var} to #{live_env}"
          dotenv_file[env_var] = live_env
        else
          puts "The value for: #{env_var} was empty in the file: #{file_name} and the local ENV. Not setting."
        end
      end
    end

    File.open(file_name, 'w') { |f| f.write(serialize_hash(dotenv_file)) }
    puts "Wrote out: #{file_name}\n\n"
  end
end

def serialize_hash(env_hash)
  output_string = ''
  env_hash.each do |k, v|
    output_string += "#{k}=\"#{v}\"\n"
  end
  output_string
end