require 'rubygems'
require 'appium_lib'

capabilities = {
  'platformName' => 'iOS',
  'deviceName' => "iPhone 6s",
  'platformVersion' => '9.3',
  'app' => "/Users/Leo/MyProjects/AppiumBooster/ios/app/test.app"
}

Appium::Driver.new(caps: capabilities).start_driver
Appium.promote_appium_methods Object
alert_accept

# testcase: login
id('btnMenuMyAccount').click
id('tablecellMyAccountLogin').click
id('txtfieldEmailAddress').type 'leo.lee@debugtalk.com'
id('sectxtfieldPassword').type '123321'
id('btnLogin').click

driver_quit
