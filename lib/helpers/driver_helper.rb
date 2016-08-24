# filename: lib/helpers/driver_helper.rb

require 'appium_lib'

class AppiumDriver

  def initialize(options)
    $LOG.info "initialize AppiumDriver ...".green
    @app_type = options[:app_type]
    @results_dir = options[:results_dir]
    @screenshots_dir = options[:screenshots_dir]
    @errors_dir = options[:errors_dir]
    init_appium_server
  end

  def init_appium_server
    $LOG.info "initialize appium server.".green
    cmd = "ps | grep 'node .*/appium'"
    IO.popen(cmd).each_line do |text|
      if text.include? "bin/appium"
        $LOG.info "kill appium server process."
        appium_pid = text.split[0].to_i
        Process.kill(:SIGINT, appium_pid)
      end
    end
    $LOG.info "start appium server process."
    system("appium | tee #{@results_dir}/appium_server.log &")
    sleep(10)
  end

  def get_capability
    appium_txt = File.join(Dir.pwd, @app_type, 'appium.txt')
    Appium.load_appium_txt file: appium_txt
  end

  def init_client_instance(capability)
    $LOG.info "initialize appium client instance with capability: #{capability}".green
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
    $LOG.info "start appium client driver ...".green
    @driver.start_driver
  end

  def driver_quit
    $LOG.info "quit appium client driver.".green
    @driver.driver_quit
  end

  def alert_accept
    @driver.alert_accept
    $LOG.info "alert accepted!".green
  rescue
    $LOG.warn "no alert found, continue."
  end

  def screenshot(png_file_name, error=false)
    png_file_name = png_file_name.strip.gsub(/\s/, '_')
    time = Time.now.strftime "%H_%M_%S"
    png_save_file = "#{time}_#{png_file_name}.png"
    @driver.screenshot File.join(@screenshots_dir, png_save_file)
    @driver.screenshot File.join(@errors_dir, png_save_file) if error
  end

end
