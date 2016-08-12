# filename: ios/run.rb

require 'optparse'
require_relative 'lib/requires'

options = {}
options[:output_color] = true
OptionParser.new do |opts|
  opts.banner = "Usage: run.rb [options]"

  opts.on("-p APP_PATH", "--app_path", "Specify app path") do |v|
    options[:app_path] = v
  end

  opts.on("--disable_output_color", "Disable output color") do
    options[:output_color] = false
  end

end.parse!

app_zip_path = options[:app_path]
OUTPUT_WITH_COLOR = options[:output_color]

$driver = AppiumDriver.new(app_zip_path).driver
project_root_path = File.dirname(__FILE__)
testcase_suites = File.join(project_root_path, 'ios', 'testcases', '*.csv')
run_all_testcase_suites(testcase_suites)
