# filename: lib/helpers/csv_helper.rb

require 'csv'

def load_scenario_csv_file(scenario_csv_file_path)
  """ load csv format scenarios file.
  output scenario_hash format example: {
    'scenario_name': 'Login and Logout',
    'testcases_suite': [
      {
        'testcase_name': 'login with valid account',
        'testcase_steps': [
          {'control_id': 'btnMenuMyAccount', 'control_action': 'click', 'expectation': 'tablecellMyAccountSystemSettings', 'step_desc': 'enter My Account page'},
          {'control_id': 'tablecellMyAccountLogin', 'control_action': 'click', 'expectation': 'btnForgetPassword', 'step_desc': 'enter Login page'},
          {'control_id': 'txtfieldEmailAddress', 'control_action': 'type', 'data': 'leo.lee@debugtalk.com', 'expectation': 'sectxtfieldPassword', 'step_desc': 'input EmailAddress'},
          {'control_id': 'sectxtfieldPassword', 'control_action': 'type', 'data': 12345678, 'expectation': 'btnLogin', 'step_desc': 'input Password'},
          {'control_id': 'btnLogin', 'control_action': 'click', 'expectation': 'tablecellMyMessage', 'step_desc': 'login'},
          {'control_id': 'btnClose', 'control_action': 'click', 'expectation': nil, 'optional': true, 'step_desc': 'close coupon popup window(optional)'}
        ]
      },
      {
        'testcase_name': 'logout',
        'testcase_steps': [
          {'control_id': 'btnMenuMyAccount', 'control_action': 'click', 'expectation': 'tablecellMyAccountSystemSettings', 'step_desc': 'enter My Account page'},
          {'control_id': 'tablecellMyAccountSystemSettings', 'control_action': 'click', 'expectation': 'txtCountryDistrict', 'step_desc': 'enter Settings page'},
          {'control_id': 'btnLogout', 'control_action': 'click', 'expectation': 'uiviewMyAccount', 'step_desc': 'logout'}
        ]
      }
    ]
  }
  """
  # $LOG.info "load scenario csv file: #{scenario_csv_file_path}".magenta
  puts "load scenario csv file: #{scenario_csv_file_path}"
  # the first line is titles by default
  row_num = 1
  scenario_hash = Hash.new
  scenario_hash['scenario_name'] = File.basename(scenario_csv_file_path, ".csv")
  scenario_hash['testcases_suite'] = Array.new
  titles = Array.new
  testcase = nil

  CSV.foreach(scenario_csv_file_path) do |row_content|
    if row_num == 1
      titles = row_content
      # check whether titles are valid
      raise if titles[0] != "testcase_name"
      row_num += 1
      next
    end

    testcase_name = row_content[0]
    step_desc = row_content[1]
    next unless (testcase_name || step_desc)
    if testcase_name
      testcase = Hash.new
      testcase["testcase_name"] = testcase_name
      testcase["testcase_steps"] = Array.new
      scenario_hash['testcases_suite'] << testcase
    end

    step = Hash.new
    row_content[1..-1].each_with_index do |cell, index|
      title = titles[index+1]
      next if title.nil?
      step[title] = cell.strip unless cell.nil?
    end
    testcase["testcase_steps"] << step

  end
  scenario_hash
end
