# frozen_string_literal: true

require 'yaml'
desc 'cleans up the yaml filterset files by removing duplicates and stuff. Run this when you change those files'
task clean_yaml: :environment do
  CleanYaml.clean((Rails.root.join '.resources', 'filter_categories').to_s)
end

class CleanYaml
  def self.clean(file_path)
    if File.directory?(file_path)
      puts "It looks like a directory was passed in. Trying to clean all files in: #{file_path} that end with '.yml'"
      absolute_path = File.absolute_path(file_path)
      Dir.glob(absolute_path + '/*.yml').each do |file|
        clean_file(file)
      end
    elsif File.exist?(file_path)
      clean_file(file_path)
    else
      puts "Could not find file: \"#{file_path}\"."
    end
  end

  def self.clean_file(file_name)
    puts "Reading file: #{file_name}"
    yaml = YAML.load_file(file_name)
    puts "Sorting file's words.."
    yaml['words'].sort_by! { |word| word.to_s.downcase }
    puts 'Removing duplicate words..'
    yaml['words'].uniq!
    puts 'Downcasing words..'
    yaml['words'].each { |word| word.to_s.downcase! }

    File.open(file_name, 'w') { |f| f.write(yaml.to_yaml) }
    puts "Wrote out: #{file_name} successfully!\n\n"
  end
end
