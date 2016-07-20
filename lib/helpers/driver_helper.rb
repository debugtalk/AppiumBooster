# filename: lib/helpers/driver_helper.rb

require 'appium_lib'

def setup_driver
  puts 'initialize appium driver ...'
  appium_txt = File.join(Dir.pwd, 'ios', 'appium.txt')
  caps = Appium.load_appium_txt file: appium_txt
  Appium::Driver.new caps
end

def promote_methods
  Appium.promote_singleton_appium_methods Pages
end

$driver = setup_driver
promote_methods
