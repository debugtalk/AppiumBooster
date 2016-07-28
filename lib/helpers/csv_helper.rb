# filename: lib/helpers/csv_helper.rb

require 'csv'

def load_csv_testcases(testcase_csv_file_path)
  """ Convert csv files to testcase structure.
  output testcases_list: [
    {
      'testcase_name': 'Login with valid account',
      'steps': [
        {
          'step_desc': 'Enter My Account Page',
          'control_id': 'btnMenuMyAccount',
          'control_action': 'click',
          'data': nil,
          'expected': 'tablecellSystemSettings'
        },
        {
          'step_desc': 'Enter Login Page',
          'control_id': 'btnMyAccountLogin',
          'control_action': 'click',
          'data': nil,
          'expected': 'btnForgetPassword'
        },
      ]
    },
  ]
  """
  puts "load csv testcase file: #{testcase_csv_file_path} ..."
  # the first line is titles by default
  row_num = 1
  testcases_list = Array.new
  titles = nil
  testcase = nil
  neccessary_titles = ["StepDesc", "ControlID", "ControlAction"]

  CSV.foreach(testcase_csv_file_path) do |row_content|
    if row_num == 1
      titles = row_content
      # check whether titles are valid
      raise if titles[0] != "TestcaseName"
      neccessary_titles.each do |neccessary_title|
        raise unless titles.include? neccessary_title
      end
      row_num += 1
      next
    end

    unless row_content[0].nil?
      testcase = Hash.new
      testcase["testcase_name"] = row_content[0]
      testcase["steps"] = Array.new
      testcases_list << testcase
    end

    step = {}
    row_content[1..-1].each_with_index do |cell, index|
      title = titles[index+1]
      next if title.nil?
      step[titles[index+1]] = cell.strip unless cell.nil?
    end

    step_valid = true
    neccessary_titles.each do |neccessary_title|
      if step[neccessary_title].nil? || step[neccessary_title] == ""
        step_valid = false
        break
      end
    end
    testcase["steps"] << step if step_valid == true

  end

  return testcases_list
end
