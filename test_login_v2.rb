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
wait { id('btnMenuMyAccount').click }
wait { id('tablecellMyAccountLogin').click }
wait { id('txtfieldEmailAddress').type 'leo.lee@debugtalk.com' }
wait { id('sectxtfieldPassword').type '123321' }
wait { id('btnLogin').click }

driver_quit
