# filename: lib/helpers/driver_helper.rb

require 'appium_lib'

class AppiumDriver

  def get_capability(app_type)
    appium_txt = File.join(Dir.pwd, app_type, 'appium.txt')
    Appium.load_appium_txt file: appium_txt
  end

  def instance(capability)
    puts "initialize appium instance with capability: #{capability}"
    setup_driver(capability)
    promote_methods
    @driver
  end

  def setup_driver(capability)
    @driver = Appium::Driver.new capability
  end

  def promote_methods
    Appium.promote_singleton_appium_methods Pages
  end

end
