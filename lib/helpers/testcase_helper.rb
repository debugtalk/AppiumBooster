# filename: lib/helpers/testcase_helper.rb

require_relative 'csv_helper'
require_relative 'operation_helper'


def exec_testcase_step(control_id, control_action, data, step_ignore=nil)
  """ execute testcase step.
  """
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

  begin
    eval step_action
  rescue
    # do not fail the testcase if the failed step is an extra step
    unless step_ignore
      raise
    end
  ensure
    return step_action
  end
end

def verify_step_expectation(expected)
  """ verify if step executed as expected.
    support two types of expectation description:
    - ControlID: the page has the ControlID after action;
    - !ControlID: the page won't have the ControlID after action.
  """
  step_verify_desc = "#{expected}"
  if expected.start_with?('!')
    expected = expected[1..-1]
    step_verify_desc += " no longer exsits?"
    inner_screen.has_no_control expected
  else
    step_verify_desc += " exsits?"
    inner_screen.has_control expected
  end
  step_verify_desc
end

def run_testcase_suite(testcase_suite)
  puts "======= start to run testcase suite: #{testcase_suite} =======".yellow
  testcases_list = load_csv_testcases(testcase_suite)
  testcases_list.each do |testcase|
    puts "B------ Start to run testcase: #{testcase['testcase_name']}".blue
    begin
      step_action_desc = ""
      testcase['steps'].each_with_index do |step, index|
        puts "step_#{index+1}: #{step['StepDesc']}"
        control_id = step['ControlID']
        control_action = step['ControlAction']
        data = step['Data']
        expected = step['Expected']
        step_ignore = step['Ignore']

        step_action_desc = exec_testcase_step(control_id, control_action, data, step_ignore)
        step_action_desc += "    ...    ✓"
        puts step_action_desc.green

        # check if testcase step executed successfully
        if expected
          step_action_desc = verify_step_expectation(expected)
          step_action_desc += "    ...    ✓"
          puts step_action_desc.green
        end

        step_action_desc = ""
      end
    # rescue Selenium::WebDriver::Error::TimeOutError => ex
    rescue => ex
      step_action_desc += "    ...    ✖"
      puts step_action_desc.red
      puts ex
      alert_accept
    end
    puts "E------ #{testcase['testcase_name']}\n".blue
  end
  puts "============ all testcases have been executed. ============".yellow
end

def run_all_testcase_suites(testcase_suites)
  Dir.glob(testcase_suites) do |testcase_suite|
    puts "start appium driver ..."
    $driver.start_driver
    alert_accept
    run_testcase_suite(testcase_suite)
    puts "quit appium driver."
    $driver.driver_quit
  end
end
