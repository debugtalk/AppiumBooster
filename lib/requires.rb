# filename: lib/requires.rb

# require the ios page checker
require_relative 'pages/inner_screen'

# require control helper
require_relative 'pages/control'

# require environment initializer
require_relative 'helpers/env_helper'

# setup driver
require_relative 'helpers/driver_helper'

# require output colorization
require_relative 'helpers/colorize'

# require the testcase helper
require_relative 'helpers/testcase_helper'

# require the logger helper
require_relative 'helpers/logger_helper'

# require testcase runner
require_relative 'runner'
