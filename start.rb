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
    options[:app_type] = v.downcase
  end

  options[:testcase_file] = "*.yml"
  opts.on("-f <value>", "--testcase_file", "Specify testcase file") do |file|
    file.downcase!
    file = "*.yml" if file == "*.yaml"
    options[:testcase_file] = file
  end

  options[:output_folder] = File.join(Dir.pwd, "results")
  opts.on("-d <value>", "--output_folder", "Specify output folder") do |v|
    options[:output_folder] = v
  end

  options[:output_color] = true
  opts.on("--disable_output_color", "Disable output color") do
    options[:output_color] = false
  end

end.parse!

OUTPUT_WITH_COLOR = options[:output_color]

run_test(options)
