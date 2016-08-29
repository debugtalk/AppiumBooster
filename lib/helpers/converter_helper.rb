# filename: lib/helpers/converter_helper.rb

require_relative 'yaml_helper'

def convert_yaml_to_csv(testcase_yaml_file_path)
  $LOG.info "Convert #{testcase_yaml_file_path} to CSV format test testcases.".green
  testcase_hash = load_testcase_yaml_file(testcase_yaml_file_path)
  features_suite = testcase_hash['features_suite']
  testcase_csv_file_name = File.basename(testcase_yaml_file_path, ".*") + ".csv"
  testcase_csv_file_path = File.expand_path(
    File.join(File.dirname(testcase_yaml_file_path), testcase_csv_file_name)
  )
  titles = ['feature_name','step_desc','control_id','control_action','data','expectation','optional']
  open(testcase_csv_file_path, 'w') do |f|
    f.puts titles.join(',')
    features_suite.each do |feature|
      feature_name = feature['feature_name']
      feature['feature_steps'].each do |step|
        line_content_list = Array.new
        line_content_list << feature_name
        titles[1..-1].each do |title|
          line_content_list << "#{step[title]}"
        end
        f.puts line_content_list.join(',')
        feature_name = nil if feature_name
      end
      f.puts ",,,,,,"
    end
  end
  $LOG.info "CSV format test testcases generated: #{testcase_csv_file_path}".green
end
