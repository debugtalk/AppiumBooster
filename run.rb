# filename: ios/run.rb

require_relative 'lib/requires'

app_zip_path = '/Users/Leo/MyProjects/AppiumBooster/ios/app/test.zip'
$driver = AppiumDriver.new(app_zip_path).driver
project_root_path = File.dirname(__FILE__)
testcase_suites = File.join(project_root_path, 'ios', 'testcases', '*.csv')
run_all_testcase_suites(testcase_suites)
