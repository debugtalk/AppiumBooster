# filename: lib/helpers/testcase_helper.rb

require_relative 'utils'
require_relative 'yaml_helper'
require_relative 'csv_helper'

def exec_feature_step(control_id, control_action, data, step_optional=nil)
  """ execute feature step.
  """
  begin
    if control_id.nil? or control_id.to_s == "N/A"
      # this type of action do not need control_id, such as 'alert_accept'
      step_action = "#{control_action}"
    elsif control_id == 'inner_screen'
      # check if the current page has specified control
      step_action = "inner_screen.#{control_action}"
      step_action += " '#{data}'"
    else
      # execute action on control, such as btnLogin.click, or txtfieldUser.type 'debugtalk'
      control_element = control.specify control_id
      step_action = "control_element.#{control_action}"
      step_action += " '#{data}'" unless data.nil?
    end

    eval step_action
  rescue
    # do not fail the testcase if the failed step is an optional step
    unless step_optional
      raise
    end
  end
end

def verify_step_expectation(expectation)
  """ verify if step executed as expectation.
  """
  inner_screen.check_elements expectation
end

def run_testcase(testcase_hash)
  testcase_name = testcase_hash['testcase_name']
  $LOG.info "======= start to run test testcase: #{testcase_name} =======".yellow
  features_suite = testcase_hash['features_suite']
  features_suite.each do |feature|
    $LOG.info "B------ Start to run feature: #{feature['feature_name']}".blue
    $LOG.info "feature: #{feature}"
    step_action_desc = ""
    begin
      feature['feature_steps'].each_with_index do |step, index|
        $LOG.info "step_#{index+1}: #{step['step_desc']}".cyan
        control_id = step['control_id']
        control_action = step['control_action']
        data = eval_expression(step['data'])
        expectation = step['expectation']
        step_optional = step['optional']

        step_action_desc = "#{control_id}.#{control_action} #{data}"
        exec_feature_step(control_id, control_action, data, step_optional)
        $appium_driver.screenshot(step_action_desc)

        # check if feature step executed successfully
        if expectation
          raise unless verify_step_expectation(expectation)
        end
        step_action_desc += "    ...    ✓"
        $LOG.info step_action_desc.green

        step_action_desc = ""
      end
    rescue => ex
      $appium_driver.screenshot(step_action_desc, error=true)
      step_action_desc += "    ...    ✖"
      $LOG.error step_action_desc.red
      $LOG.error "#{ex}".red
    end
    $LOG.info "E------ #{feature['feature_name']}\n".blue
  end # features_suite
  $LOG.info "============ all features have been executed. ============".yellow
end

def parse_testcase_file(testcase_file)
  if testcase_file.end_with? ".csv"
    testcase_hash = load_testcase_csv_file(testcase_file)
  elsif testcase_file.end_with? ".yml"
    testcase_hash = load_testcase_yaml_file(testcase_file)
  else
    raise "Only support yaml and csv format!"
  end
  testcase_hash
end

def run_all_testcases(testcase_files)
  Dir.glob(testcase_files) do |testcase_file|
    testcase_file = File.expand_path(testcase_file)
    testcase_hash = parse_testcase_file(testcase_file)
    $LOG.info "testcase_hash: #{testcase_hash}"
    next if testcase_hash.empty? || testcase_hash['features_suite'].empty?
    $appium_driver.start_driver
    # $appium_driver.alert_accept
    run_testcase(testcase_hash)
    $appium_driver.driver_quit
  end
end
