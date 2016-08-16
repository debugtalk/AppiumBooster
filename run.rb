# filename: ios/run.rb

require 'optparse'
require_relative 'lib/requires'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: run.rb [options]"

  opts.on("-p APP_PATH", "--app_path", "Specify app path") do |v|
    options[:app_path] = v
  end

  options[:app_type] = "ios"
  opts.on("-t APP_TYPE", "--app_type", "Specify app type, ios or android") do |v|
    options[:app_type] = v.downcase
  end

  options[:output_color] = true
  opts.on("--disable_output_color", "Disable output color") do
    options[:output_color] = false
  end

end.parse!

app_zip_path = options[:app_path]
OUTPUT_WITH_COLOR = options[:output_color]

$driver = AppiumDriver.new(app_zip_path).driver
project_root_path = File.dirname(__FILE__)
app_type = options[:app_type]
testcase_suites = File.join(project_root_path, app_type, 'testcases', '*.csv')
run_all_testcase_suites(testcase_suites)
