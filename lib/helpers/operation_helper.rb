# filename: lib/helpers/operation_helper.rb

def alert_accept
  begin
    $driver.alert_accept
    puts "alert accepted!"
  rescue
    puts "no alert found, continue."
  end
end
