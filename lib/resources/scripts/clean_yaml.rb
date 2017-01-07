require 'yaml'

class CleanYaml
  def self.clean(file_name)
    yaml = YAML.load_file(file_name).flatten
    puts "Read file: #{file_name} with contents:"
    puts yaml
    puts 'Sorting file and removing duplicates:'
    puts yaml.sort_by! { |word| word.to_s.downcase }.uniq!
    File.open(file_name, 'w') { |f| f.write(yaml.to_yaml) }
    puts "Wrote out: #{file_name} successfully!"
  end
end