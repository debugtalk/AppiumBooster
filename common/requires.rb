# filename: common/requires.rb

# load lib
require 'rspec'
require 'appium_lib'

# require page helpers
require_relative '../ios/pages/helpers/inner_screen'
require_relative '../ios/pages/helpers/actions'

# require page objects
require_relative '../ios/pages/my_account.rb'
require_relative '../ios/pages/login.rb'
require_relative '../ios/pages/settings.rb'
require_relative '../ios/pages/select_country.rb'

# setup rspec
require_relative 'spec_helper'
