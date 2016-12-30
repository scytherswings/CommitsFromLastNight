require 'yaml'
require 'csv'
class Filter
  attr_reader :blacklist_file, :whitelist_file

  def initialize
    @blacklist_file = Array.new
    @whitelist_file = Array.new
  end

  def import_yaml(blacklist_file, whitelist_file = nil)
    @blacklist_file | YAML.load_file(blacklist_file).flatten
    unless whitelist_file.blank?
      @whitelist_file | YAML.load_file(whitelist_file).flatten
    end
  end

  def import_csv(blacklist_file, whitelist_file = nil)
    @blacklist_file | CSV.read(blacklist_file).flatten
    unless whitelist_file.blank?
      @whitelist_file | CSV.read(whitelist_file).flatten
    end
  end


end