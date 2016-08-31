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

def load_features_lib
  """ load yaml format features library.
  output features_lib_hash format: {
    'AccountFeatures': {
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
    'SettingsFeatures': {
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
  features_lib_hash = Hash.new
  features_yaml_files = File.expand_path(File.join(Dir.pwd, 'ios', 'features', "*.yml"))
  Dir.glob(features_yaml_files).each do |features_yaml_file_path|
    $LOG.info "load features yaml file: #{features_yaml_file_path}".cyan
    features = YAML.load_file(features_yaml_file_path)
    features.each do |features_suite_name, features_suite_hash|
      features_lib_hash[features_suite_name] = Hash.new
      features_suite_hash.each do |feature_name, feature_steps_list|
        features_lib_hash[features_suite_name][feature_name] = Array.new
        feature_steps_list.each do |step|
          steps_suite_name, step_name = step.split('|')
          steps_suite_name.strip!
          step_name.strip!
          step_hash = steps_lib_hash[steps_suite_name][step_name] || Hash.new
          step_hash['step_desc'] = step_name
          features_lib_hash[features_suite_name][feature_name] << step_hash
        end
      end
      $LOG.debug "#{features_suite_name}: #{features_lib_hash[features_suite_name]}"
    end
  end
  $LOG.debug "features_lib_hash: #{features_lib_hash}"
  features_lib_hash
end

def load_testcase_yaml_file(testcase_yaml_file_path)
  """ load yaml format testcase file.
  output testcase_hash format: {
    'testcase_name': 'Login and Logout',
    'features_suite': [
      features_lib_hash['AccountFeatures']['login with valid account'],
      features_lib_hash['AccountFeatures']['logout'],
    ]
  }
  """
  $LOG.info "load testcase yaml file: #{testcase_yaml_file_path}".magenta
  features_lib_hash = load_features_lib()

  testcase_hash = Hash.new
  YAML.load_file(testcase_yaml_file_path).each do |testcase_name, features_suite|
    testcase_hash['testcase_name'] = testcase_name
    testcase_hash['features_suite'] = Array.new
    features_suite.each do |feature|
      features_suite_name, feature_name, run_times = feature.strip.split('|')
      features_suite_name.strip!
      feature_name.strip!
      run_times ||= "1"
      run_times = run_times.strip.to_i
      run_times.times.each do |t|
        feature_hash = Hash.new
        feature_hash['feature_name'] = feature_name
        feature_hash['feature_steps'] = features_lib_hash[features_suite_name][feature_name] || Array.new
        testcase_hash['features_suite'] << feature_hash
      end
    end
    $LOG.debug "#{testcase_name}: #{testcase_hash}"
  end
  testcase_hash
end
