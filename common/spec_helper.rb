# filename: common/spec_helper.rb

def setup_driver
  return if $driver
  appium_txt = File.join(Dir.pwd, 'ios', 'appium.txt')
  caps = Appium.load_appium_txt file: appium_txt
  Appium::Driver.new caps
end

def promote_methods
  Appium.promote_appium_methods RSpec::Core::ExampleGroup
end

setup_driver
promote_methods

RSpec.configure do |config|

  config.before(:each) do
    $driver.start_driver
    wait { alert_accept }
  end

  config.after(:each) do
    driver_quit
  end

end
