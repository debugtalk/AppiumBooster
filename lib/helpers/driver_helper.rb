# filename: lib/helpers/driver_helper.rb

require 'appium_lib'

class AppiumDriver

  def initialize(app_zip_path=nil)
    setup_driver(app_zip_path)
    promote_methods
  end

  def driver
    @driver
  end

  def setup_driver(app_zip_path)
    puts 'initialize appium driver ...'
    appium_txt = File.join(Dir.pwd, 'ios', 'appium.txt')
    caps = Appium.load_appium_txt file: appium_txt
    caps[:caps][:app] = app_zip_path if app_zip_path
    @driver = Appium::Driver.new caps
  end

  def promote_methods
    Appium.promote_singleton_appium_methods Pages
  end

end
