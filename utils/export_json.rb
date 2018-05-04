require 'pp'
require 'json'
require 'yaml'
require 'csv'

$DEBUG = false

project_root = ENV['USERPROFILE'] + '/dev/environment'

mapping_file = 'environment.yaml'
filters = {}
file_path = project_root + '/' + mapping_file
@nodes = (File.exists?(file_path)) ? YAML.load_file( file_path ) : nil

if ! @nodes.nil?
  if $DEBUG
    puts "Loaded #{@nodes.keys.size} nodes"
    pp @nodes.keys[0...5]
  end
end

target_file = mapping_file.gsub('.yaml','.json')
File.open(target_file, 'w') do |f|
  f.write(@nodes.to_json )
end
