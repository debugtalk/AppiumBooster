# filename: start.rb

require 'optparse'
require_relative 'lib/requires'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: start.rb [options]"

  opts.on("-p <value>", "--app_path", "Specify app path") do |v|
    options[:app_path] = v
  end

  options[:app_type] = "ios"
  opts.on("-t <value>", "--app_type", "Specify app type, ios or android") do |v|
    app_type = v.downcase
    unless ["ios", "android"].include? app_type
      raise ArgumentError, "app_type should only be ios or android!"
    end
    options[:app_type] = app_type
  end

  options[:testcase_file] = "*.yml"
  opts.on("-f <value>", "--testcase_file", "Specify testcase file(s)") do |file|
    file.downcase!
    file = "*.yml" if file == "*.yaml"
    options[:testcase_file] = file
  end

  options[:output_folder] = File.join(Dir.pwd, "results")
  opts.on("-d <value>", "--output_folder", "Specify output folder") do |v|
    options[:output_folder] = v
  end

  options[:convert_type] = "yaml2csv"
  opts.on("-c <value>", "--convert_type", "Specify testcase converter, yaml2csv or csv2yaml") do |v|
    options[:convert_type] = v
  end

  options[:output_color] = true
  opts.on("--disable_output_color", "Disable output color") do
    options[:output_color] = false
  end

end.parse!

initialize_project_environment options
OUTPUT_WITH_COLOR = options[:output_color]

if options[:app_path] && options[:app_type]
  run_test(options)
elsif options[:convert_type] && File.file?(options[:testcase_file])
  convert_yaml_to_csv(options[:testcase_file]) if options[:convert_type] == "yaml2csv"
else
  raise ArgumentError
end
