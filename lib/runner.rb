# filename: lib/runner.rb

def run_test(options)
  initialize_project_environment options
  app_path = options[:app_path]
  app_type = options[:app_type]
  testcase_file = options[:testcase_file]

  config_list = Array.new

  $appium_driver = AppiumDriver.new options
  capability = $appium_driver.get_capability
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

    begin
      $appium_driver.init_client_instance(capability)

      if File.exists? testcase_file
        testcase_files = testcase_file
      else
        testcases_dir = File.join(File.dirname(__FILE__), app_type, 'testcases')
        testcase_files = File.join(testcases_dir, "#{testcase_file}")
      end

      run_all_testcase_suites(testcase_files)
    rescue => ex
      $LOG.error "#{ex}".red
    ensure
      $LOG.info "\n#{'>'*60}===#{'<'*60}\n".yellow
    end
  end
end
