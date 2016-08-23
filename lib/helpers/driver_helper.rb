# filename: lib/helpers/driver_helper.rb

require 'appium_lib'

class AppiumDriver

  def initialize(options)
    puts "initialize AppiumDriver ...".green
    @app_type = options[:app_type]
    @output_folder = options[:output_folder]
    init_env
    init_appium_server
  end

  def init_env
    puts "initialize project environment.".green

    unless File.exists?(@output_folder)
      puts "create output folder."
      Dir.mkdir(@output_folder)
    end

    time = Time.now.strftime "%Y-%m-%d_%H:%M:%S"
    @results_dir = File.expand_path(File.join(@output_folder, "#{time}"))
    unless File.exists?(@results_dir)
      puts "create results directory."
      Dir.mkdir(@results_dir)
      @screenshots_dir = File.join(@results_dir, "screenshots")
      Dir.mkdir(@screenshots_dir)
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
    system("appium | tee #{@results_dir}/appium_server.log &")
    sleep(10)
  end

  def get_capability
    appium_txt = File.join(Dir.pwd, @app_type, 'appium.txt')
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

  def screenshot(png_file_name)
    png_file_name = png_file_name.gsub(/\s/, '_')
    time = Time.now.strftime "%H_%M_%S"
    png_save_path = File.expand_path(
      File.join(@screenshots_dir, "#{time}_#{png_file_name}.png")
    )
    @driver.screenshot png_save_path
  end

end
