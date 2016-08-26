# filename: lib/runner.rb

def run_test(options)
  initialize_project_environment options
  app_path = options[:app_path]
  app_type = options[:app_type]
  scenario_file = options[:scenario_file]

  config_list = Array.new

  $appium_driver = AppiumDriver.new options
  capability = $appium_driver.get_capability
  capability[:caps][:app] = app_path if app_path

  ios_devices = capability.delete(:scenario).delete(:ios_devices)
  ios_devices.each do |device|
    config = Hash.new
    config["deviceName"] = device[0]
    config["platformVersion"] = device[1]
    recreate_ios_simulator device[0], device[1]
    config_list << config
  end

  config_list.each do |config|
    capability[:caps][:deviceName] = config["deviceName"]
    capability[:caps][:platformVersion] = config["platformVersion"]

    begin
      $appium_driver.init_client_instance(capability)

      if File.exists? scenario_file
        scenario_files = scenario_file
      else
        testcases_dir = File.join(File.dirname(__FILE__), app_type, 'scenarios')
        scenario_files = File.join(testcases_dir, "#{scenario_file}")
      end

      run_all_test_scenarios(scenario_files)
    rescue => ex
      $LOG.error "#{ex}".red
    ensure
      $LOG.info "\n#{'>'*60}===#{'<'*60}\n".yellow
    end
  end
end
