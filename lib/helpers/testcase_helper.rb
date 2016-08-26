# filename: lib/helpers/testcase_helper.rb

require_relative 'yaml_helper'
require_relative 'csv_helper'

def exec_testcase_step(control_id, control_action, data, step_optional=nil)
  """ execute testcase step.
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

def run_test_scenario(scenario_hash)
  scenario_name = scenario_hash['scenario_name']
  $LOG.info "======= start to run test scenario: #{scenario_name} =======".yellow
  testcases_suite = scenario_hash['testcases_suite']
  testcases_suite.each do |testcase|
    $LOG.info "B------ Start to run testcase: #{testcase['testcase_name']}".blue
    $LOG.info "testcase: #{testcase}"
    step_action_desc = ""
    begin
      testcase['testcase_steps'].each_with_index do |step, index|
        $LOG.info "step_#{index+1}: #{step['step_desc']}".cyan
        control_id = step['control_id']
        control_action = step['control_action']
        data = step['data']
        expectation = step['expectation']
        step_optional = step['optional']

        # add support for passing ruby expression as data parameter
        if data && data.class == String
          data.gsub!(/\$\{(.*?)\}/) do
            eval($1)
          end
        end

        step_action_desc = "#{control_id}.#{control_action} #{data}"
        exec_testcase_step(control_id, control_action, data, step_optional)
        $appium_driver.screenshot(step_action_desc)

        # check if testcase step executed successfully
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
    $LOG.info "E------ #{testcase['testcase_name']}\n".blue
  end # testcases_suite
  $LOG.info "============ all testcases have been executed. ============".yellow
end

def parse_scenario_file(scenario_file)
  if scenario_file.end_with? ".csv"
    scenario_hash = load_scenario_csv_file(scenario_file)
  elsif scenario_file.end_with? ".yml"
    scenario_hash = load_scenario_yaml_file(scenario_file)
  else
    raise "Only support yaml and csv format!"
  end
  scenario_hash
end

def run_all_test_scenarios(scenario_files)
  Dir.glob(scenario_files) do |scenario_file|
    scenario_file = File.expand_path(scenario_file)
    scenario_hash = parse_scenario_file(scenario_file)
    next if scenario_hash.empty? || scenario_hash['testcases_suite'].empty?
    $appium_driver.start_driver
    # $appium_driver.alert_accept
    run_test_scenario(scenario_hash)
    $appium_driver.driver_quit
  end
end
