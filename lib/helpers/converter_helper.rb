# filename: lib/helpers/converter_helper.rb

require_relative 'yaml_helper'

def convert_yaml_to_csv(scenario_yaml_file_path)
  $LOG.info "Convert #{scenario_yaml_file_path} to CSV format test scenarios.".green
  scenario_hash = load_scenario_yaml_file(scenario_yaml_file_path)
  testcases_suite = scenario_hash['testcases_suite']
  scenario_csv_file_name = File.basename(scenario_yaml_file_path, ".*") + ".csv"
  scenario_csv_file_path = File.expand_path(
    File.join(File.dirname(scenario_yaml_file_path), scenario_csv_file_name)
  )
  titles = ['testcase_name','step_desc','control_id','control_action','data','expectation','optional']
  open(scenario_csv_file_path, 'w') do |f|
    f.puts titles.join(',')
    testcases_suite.each do |testcase|
      testcase_name = testcase['testcase_name']
      testcase['testcase_steps'].each do |step|
        line_content_list = Array.new
        line_content_list << testcase_name
        titles[1..-1].each do |title|
          line_content_list << "#{step[title]}"
        end
        f.puts line_content_list.join(',')
        testcase_name = nil if testcase_name
      end
      f.puts ",,,,,,"
    end
  end
  $LOG.info "CSV format test scenarios generated: #{scenario_csv_file_path}".green
end
