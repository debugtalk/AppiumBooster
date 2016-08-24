# filename: lib/helpers/yaml_helper.rb

require 'yaml'

def load_steps_lib
  steps_lib_hash = Hash.new
  steps_yaml_files = File.expand_path(File.join(Dir.pwd, 'ios', 'steps', "*.yml"))
  Dir.glob(steps_yaml_files).each do |steps_yaml_file_path|
    next unless steps_yaml_file_path.end_with? "Steps.yml"
    $LOG.info "load steps yaml file: #{steps_yaml_file_path}".cyan
    steps = YAML.load_file(steps_yaml_file_path)
    $LOG.info "steps: #{steps}"
    steps_lib_hash.merge!(steps)
  end
  steps_lib_hash
end

def load_yaml_testcases(testcase_yaml_file_path)
  """ Convert yaml files to testcase structure.
  output testcases_list: [
    {
      'testcase_name': 'Login with valid account',
      'steps': [
        {
          'step_desc': 'Enter My Account Page',
          'control_id': 'btnMenuMyAccount',
          'control_action': 'click',
          'data': nil,
          'expectation': 'tablecellMyAccountSystemSettings'
        },
        {
          'step_desc': 'Enter Login Page',
          'control_id': 'tablecellMyAccountLogin',
          'control_action': 'click',
          'data': nil,
          'expectation': 'btnForgetPassword'
        },
      ]
    },
  ]
  """
  $LOG.info "load testcase yaml file: #{testcase_yaml_file_path}".magenta
  steps_lib_hash = load_steps_lib()
  testcases_list = Array.new
  YAML.load_file(testcase_yaml_file_path).each do |_, testcases|
    testcases.each do |testcase_name, testcase_steps|
      testcase = Hash.new
      testcase["testcase_name"] = testcase_name
      testcase["steps"] = Array.new
      testcase_steps.each do |step|
        module_name, step_name = step.split('|')
        module_name = module_name.strip
        step_name = step_name.strip
        step_hash = steps_lib_hash[module_name][step_name] || Hash.new
        step_hash["step_desc"] = step_name
        testcase["steps"] << step_hash
      end
      testcases_list << testcase
    end
  end
  testcases_list
end
