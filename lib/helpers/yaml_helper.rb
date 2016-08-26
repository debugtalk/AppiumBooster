# filename: lib/helpers/yaml_helper.rb

require 'yaml'

def load_steps_lib
  """ load yaml format steps library.
  output steps_lib_hash format: {
    'AccountSteps': {
      'enter My Account page': {
        'control_id': 'btnMenuMyAccount',
        'control_action': 'click',
        'expectation': 'tablecellMyAccountSystemSettings'
      },
      'input EmailAddress': {
        'control_id': 'txtfieldEmailAddress',
        'control_action': 'type',
        'data': 'leo.lee@debugtalk.com',
        'expectation': 'sectxtfieldPassword'
      }
    },
    'SettingsSteps': {
      'enter Settings page': {
        'control_id': 'tablecellMyAccountSystemSettings',
        'control_action': 'click',
        'expectation': 'txtCountryDistrict'
      }
    }
  }
  """
  steps_lib_hash = Hash.new
  steps_yaml_files = File.expand_path(File.join(Dir.pwd, 'ios', 'steps', "*.yml"))
  Dir.glob(steps_yaml_files).each do |steps_yaml_file_path|
    $LOG.info "load steps yaml file: #{steps_yaml_file_path}".cyan
    steps = YAML.load_file(steps_yaml_file_path)
    $LOG.debug "steps: #{steps}"
    steps_lib_hash.merge!(steps)
  end
  $LOG.debug "steps_lib_hash: #{steps_lib_hash}"
  steps_lib_hash
end

def load_testcases_lib
  """ load yaml format testcases library.
  output testcases_lib_hash format: {
    'AccountTestcases': {
      'login with valid account': [
        steps_lib_hash['AccountSteps']['enter My Account page'],
        steps_lib_hash['AccountSteps']['enter Login page'],
        steps_lib_hash['AccountSteps']['input EmailAddress'],
        steps_lib_hash['AccountSteps']['input Password'],
        steps_lib_hash['AccountSteps']['login'],
      ],
      'logout': [
        steps_lib_hash['AccountSteps']['enter My Account page'],
        steps_lib_hash['SettingsSteps']['enter Settings page'],
        steps_lib_hash['AccountSteps']['logout'],
      ]
    },
    'SettingsTestcases': {
      'Change Country to China': [
        steps_lib_hash['SettingsSteps']['enter My Account page'],
        steps_lib_hash['SettingsSteps']['enter Settings page'],
        steps_lib_hash['SettingsSteps']['enter Select Country page'],
        steps_lib_hash['SettingsSteps']['select China'],
        steps_lib_hash['SettingsSteps']['back to last page'],
      ]
    }
  }
  """
  steps_lib_hash = load_steps_lib()
  testcases_lib_hash = Hash.new
  testcases_yaml_files = File.expand_path(File.join(Dir.pwd, 'ios', 'testcases', "*.yml"))
  Dir.glob(testcases_yaml_files).each do |testcases_yaml_file_path|
    $LOG.info "load testcases yaml file: #{testcases_yaml_file_path}".cyan
    testcases = YAML.load_file(testcases_yaml_file_path)
    testcases.each do |testcases_suite_name, testcases_suite_hash|
      testcases_lib_hash[testcases_suite_name] = Hash.new
      testcases_suite_hash.each do |testcase_name, testcase_steps_list|
        testcases_lib_hash[testcases_suite_name][testcase_name] = Array.new
        testcase_steps_list.each do |step|
          steps_suite_name, step_name = step.split('|')
          steps_suite_name.strip!
          step_name.strip!
          step_hash = steps_lib_hash[steps_suite_name][step_name] || Hash.new
          step_hash['step_desc'] = step_name
          testcases_lib_hash[testcases_suite_name][testcase_name] << step_hash
        end
      end
      $LOG.debug "#{testcases_suite_name}: #{testcases_lib_hash[testcases_suite_name]}"
    end
  end
  $LOG.debug "testcases_lib_hash: #{testcases_lib_hash}"
  testcases_lib_hash
end

def load_scenario_yaml_file(scenario_yaml_file_path)
  """ load yaml format scenarios file.
  output scenario_hash format: {
    'scenario_name': 'Login and Logout',
    'testcases_suite': [
      testcases_lib_hash['AccountTestcases']['login with valid account'],
      testcases_lib_hash['AccountTestcases']['logout'],
    ]
  }
  """
  testcases_lib_hash = load_testcases_lib()
  $LOG.info "load scenario yaml file: #{scenario_yaml_file_path}".magenta

  scenario_hash = Hash.new
  YAML.load_file(scenario_yaml_file_path).each do |scenario_name, testcases_suite|
    scenario_hash['scenario_name'] = scenario_name
    scenario_hash['testcases_suite'] = Array.new
    testcases_suite.each do |testcase|
      testcases_suite_name, testcase_name = testcase.split('|')
      testcases_suite_name.strip!
      testcase_name.strip!
      testcase_hash = Hash.new
      testcase_hash['testcase_name'] = testcase_name
      testcase_hash['testcase_steps'] = testcases_lib_hash[testcases_suite_name][testcase_name] || Array.new
      scenario_hash['testcases_suite'] << testcase_hash
    end
    $LOG.debug "#{scenario_name}: #{scenario_hash}"
  end
  scenario_hash
end
