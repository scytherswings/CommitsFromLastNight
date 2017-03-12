#!/usr/bin/env ruby
require 'yaml'

class CleanYaml
  def self.clean(file_name)
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

if __FILE__ == $0
  ARGV.each do |argument|
    if File.directory?(argument)
      puts "\n\nIt looks like a directory was passed in. Trying to clean all files in: #{argument} that end with '.yml'"
      absolute_path = File.absolute_path(argument)
      Dir.glob(absolute_path + '/*.yml').each do |arg|
        CleanYaml.clean(arg)
      end
    elsif File.exists?(argument)
      CleanYaml.clean(argument)
    else
      puts "Could not find file: \"#{argument}\". Is it reachable from: \"#{Dir.pwd}\"?"
    end

  end
end