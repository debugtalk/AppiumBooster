# filename: lib/helpers/operation_helper.rb

def accept_alert
  begin
    puts "accept alert."
    $driver.alert_accept
  rescue
    puts "no alert found, continue."
  end
end
