# filename: lib/helpers/csv_helper.rb

require 'csv'

def load_testcase_csv_file(testcase_csv_file_path)
  """ load csv format testcase file.
  output testcase_hash format example: {
    'testcase_name': 'Login and Logout',
    'features_suite': [
      {
        'feature_name': 'login with valid account',
        'feature_steps': [
          {'control_id': 'btnMenuMyAccount', 'control_action': 'click', 'expectation': 'tablecellMyAccountSystemSettings', 'step_desc': 'enter My Account page'},
          {'control_id': 'tablecellMyAccountLogin', 'control_action': 'click', 'expectation': 'btnForgetPassword', 'step_desc': 'enter Login page'},
          {'control_id': 'txtfieldEmailAddress', 'control_action': 'type', 'data': 'leo.lee@debugtalk.com', 'expectation': 'sectxtfieldPassword', 'step_desc': 'input EmailAddress'},
          {'control_id': 'sectxtfieldPassword', 'control_action': 'type', 'data': 12345678, 'expectation': 'btnLogin', 'step_desc': 'input Password'},
          {'control_id': 'btnLogin', 'control_action': 'click', 'expectation': 'tablecellMyMessage', 'step_desc': 'login'},
          {'control_id': 'btnClose', 'control_action': 'click', 'expectation': nil, 'optional': true, 'step_desc': 'close coupon popup window(optional)'}
        ]
      },
      {
        'feature_name': 'logout',
        'feature_steps': [
          {'control_id': 'btnMenuMyAccount', 'control_action': 'click', 'expectation': 'tablecellMyAccountSystemSettings', 'step_desc': 'enter My Account page'},
          {'control_id': 'tablecellMyAccountSystemSettings', 'control_action': 'click', 'expectation': 'txtCountryDistrict', 'step_desc': 'enter Settings page'},
          {'control_id': 'btnLogout', 'control_action': 'click', 'expectation': 'uiviewMyAccount', 'step_desc': 'logout'}
        ]
      }
    ]
  }
  """
  $LOG.info "load testcase csv file: #{testcase_csv_file_path}".magenta
  # the first line is titles by default
  row_num = 1
  testcase_hash = Hash.new
  testcase_hash['testcase_name'] = File.basename(testcase_csv_file_path, ".csv")
  testcase_hash['features_suite'] = Array.new
  titles = Array.new
  feature = nil

  CSV.foreach(testcase_csv_file_path) do |row_content|
    if row_num == 1
      titles = row_content
      # check whether titles are valid
      raise if titles[0] != "feature_name"
      row_num += 1
      next
    end

    feature_name = row_content[0]
    step_desc = row_content[1]
    next unless (feature_name || step_desc)
    if feature_name
      feature = Hash.new
      feature["feature_name"] = feature_name
      feature["feature_steps"] = Array.new
      testcase_hash['features_suite'] << feature
    end

    step = Hash.new
    row_content[1..-1].each_with_index do |cell, index|
      title = titles[index+1]
      next if title.nil?
      step[title] = cell.strip unless cell.nil?
    end
    feature["feature_steps"] << step

  end
  testcase_hash
end
