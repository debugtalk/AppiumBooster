# filename: lib/helpers/testcase_helper.rb

require_relative 'csv_helper'
require_relative 'yaml_helper'


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

def run_testcase_suite(testcase_file, testcases_list)
  puts "======= start to run testcase suite: #{testcase_file} =======".yellow
  testcases_list.each do |testcase|
    puts "B------ Start to run testcase: #{testcase['testcase_name']}".blue
    puts "testcase: #{testcase}"
    step_action_desc = ""
    begin
      testcase['steps'].each_with_index do |step, index|
        puts "step_#{index+1}: #{step['step_desc']}".cyan
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
        puts step_action_desc.green

        step_action_desc = ""
      end
    rescue => ex
      step_action_desc += "    ...    ✖"
      puts step_action_desc.red
      puts "Exception: #{ex}"
      $appium_driver.screenshot(step_action_desc, error=true)
    end
    puts "E------ #{testcase['testcase_name']}\n".blue
  end
  puts "============ all testcases have been executed. ============".yellow
end

def parse_testcase_file(testcase_file)
  if testcase_file.end_with? ".csv"
    testcases_list = load_csv_testcases(testcase_file)
  elsif testcase_file.end_with? ".yml"
    testcases_list = load_yaml_testcases(testcase_file)
  else
    raise "Only support yaml and csv format!"
  end
  testcases_list
end

def run_all_testcase_suites(testcase_files)
  Dir.glob(testcase_files) do |testcase_file|
    testcase_file = File.expand_path(testcase_file)
    testcases_list = parse_testcase_file(testcase_file)
    next if testcases_list.empty?
    $appium_driver.start_driver
    # $appium_driver.alert_accept
    run_testcase_suite(testcase_file, testcases_list)
    $appium_driver.driver_quit
  end
end
