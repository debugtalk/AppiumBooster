# filename: lib/helpers/simulator_helper.rb

def get_device_type_id device_type
  # device_type format: e.g. iPhone 5s
  device_types_output = `xcrun simctl list devicetypes`
  device_type_ids = device_types_output.scan /#{device_type} \((.*)\)/
  device_type_ids[0][0]
end

def get_runtime_id runtime
  # runtime format: X.X, e.g. 9.3
  runtime = "iOS #{runtime}"
  runtimes_output = `xcrun simctl list runtimes`
  runtime_ids = runtimes_output.scan /#{runtime} \(.*\) \((com.apple[^)]+)\)$/
  runtime_ids[0][0]
end

def delete_existed_simulators(device_type, runtime)
  devices_output = `xcrun simctl list devices`
  devices = devices_output.scan /\s#{device_type}\s\(([^)]+)\).*/
  devices.each do |device|
    $LOG.info "Remove iOS simulator: #{device_type} (#{runtime}) (#{device[0]})".green
    `xcrun simctl delete #{device[0]}`
  end
end

def recreate_ios_simulator(device_type, runtime)
  device_type_id = get_device_type_id(device_type)
  runtime_id = get_runtime_id(runtime)
  delete_existed_simulators(device_type, runtime)
  simulator = `xcrun simctl create '#{device_type}' #{device_type_id} #{runtime_id}`
  $LOG.info "Create iOS simulator: #{device_type} (#{runtime}) (#{simulator.strip})".green
end
