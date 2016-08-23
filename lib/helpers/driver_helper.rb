# filename: lib/helpers/driver_helper.rb

require 'appium_lib'

class AppiumDriver

  def initialize
    puts "initialize AppiumDriver ...".green
    init_env
    init_appium_server
  end

  def init_env
    puts "initialize project environment.".green
    @logs_dir = File.expand_path(File.join(Dir.pwd, "logs"))
    unless File.exists?(@logs_dir)
      puts "create logs folder."
      Dir.mkdir(@logs_dir)
    end
  end

  def init_appium_server
    puts "initialize appium server.".green
    cmd = "ps | grep 'node .*/appium'"
    IO.popen(cmd).each_line do |text|
      if text.include? "bin/appium"
        puts "kill appium server process."
        appium_pid = text.split[0].to_i
        Process.kill(:SIGINT, appium_pid)
      end
    end
    puts "start appium server process."
    time = Time.now.strftime "%Y-%m-%d-%H:%M:%S"
    system("appium | tee #{@logs_dir}/appium_server_#{time}.log &")
    sleep(10)
  end

  def get_capability(app_type)
    appium_txt = File.join(Dir.pwd, app_type, 'appium.txt')
    Appium.load_appium_txt file: appium_txt
  end

  def init_client_instance(capability)
    puts "initialize appium client instance with capability: #{capability}".green
    setup_driver(capability)
    promote_methods
  end

  def setup_driver(capability)
    @driver = Appium::Driver.new capability
  end

  def promote_methods
    Appium.promote_singleton_appium_methods Pages
  end

  def start_driver
    puts "start appium client driver ...".green
    @driver.start_driver
  end

  def driver_quit
    puts "quit appium client driver.".green
    @driver.driver_quit
  end

  def alert_accept
    @driver.alert_accept
    puts "alert accepted!".green
  rescue
    puts "no alert found, continue."
  end

end
