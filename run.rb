# filename: ios/run.rb

require 'optparse'
require_relative 'lib/requires'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: run.rb [options]"

  opts.on("-p APP_PATH", "--app_path", "Specify app path") do |v|
    options[:app_path] = v
  end

end.parse!

app_zip_path = options[:app_path]
$driver = AppiumDriver.new(app_zip_path).driver
project_root_path = File.dirname(__FILE__)
testcase_suites = File.join(project_root_path, 'ios', 'testcases', '*.csv')
run_all_testcase_suites(testcase_suites)
