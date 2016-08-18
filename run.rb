# filename: ios/run.rb

require 'optparse'
require_relative 'lib/requires'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: run.rb [options]"

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

  options[:output_color] = true
  opts.on("--disable_output_color", "Disable output color") do
    options[:output_color] = false
  end

end.parse!

app_path = options[:app_path]
app_type = options[:app_type]
OUTPUT_WITH_COLOR = options[:output_color]

config_list = Array.new

appium_driver = AppiumDriver.new
capability = appium_driver.get_capability(app_type)
capability[:caps][:app] = app_path if app_path

ios_devices = capability.delete(:scenario).delete(:ios_devices)
ios_devices.each do |device|
  config = Hash.new
  config["deviceName"] = device[0]
  config["platformVersion"] = device[1]
  config_list << config
end

config_list.each do |config|
  capability[:caps][:deviceName] = config["deviceName"]
  capability[:caps][:platformVersion] = config["platformVersion"]
  puts "Run test with device capability: #{capability}"

  begin
    $driver = appium_driver.instance(capability)

    testcase_file = options[:testcase_file]
    if File.exists? testcase_file
      testcase_files = testcase_file
    else
      testcases_dir = File.join(File.dirname(__FILE__), app_type, 'testcases')
      testcase_files = File.join(testcases_dir, "#{testcase_file}")
    end

    run_all_testcase_suites(testcase_files)
  rescue => ex
    puts "Exception occurred: #{ex}".red
  ensure
    puts "\n#{'>'*60}===#{'<'*60}\n".yellow
  end
end
