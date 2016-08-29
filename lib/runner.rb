# filename: lib/runner.rb

def run_test(options)
  app_path = options[:app_path]
  app_type = options[:app_type]
  testcase_file = options[:testcase_file]

  $appium_driver = AppiumDriver.new options
  capability = $appium_driver.get_capability
  capability[:caps][:app] = app_path if app_path

  if app_type == "ios"
    ios_devices = capability.delete(:simulators).delete(:ios_devices)
    devices_list = initialize_ios_simulators(ios_devices)
  else
    raise "android test is not implemented currently."
  end

  devices_list.each do |device|
    capability[:caps][:deviceName] = device["deviceName"]
    capability[:caps][:platformVersion] = device["platformVersion"]

    begin
      $appium_driver.init_client_instance(capability)

      if File.exists? testcase_file
        testcase_files = testcase_file
      else
        testcases_dir = File.join(File.dirname(__FILE__), app_type, 'testcases')
        testcase_files = File.join(testcases_dir, "#{testcase_file}")
      end
      run_all_testcases(testcase_files)
    rescue => ex
      $LOG.error "#{ex}".red
    ensure
      $LOG.info "\n#{'>'*60}===#{'<'*60}\n".yellow
    end
  end
end
