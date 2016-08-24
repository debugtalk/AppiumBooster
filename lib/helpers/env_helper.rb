# filename: lib/helpers/env_helper.rb

def initialize_project_environment(options)
  output_folder = options[:output_folder]

  unless File.exists?(output_folder)
    Dir.mkdir(output_folder)
  end

  time = Time.now.strftime "%Y-%m-%d_%H:%M:%S"
  results_dir = File.expand_path(File.join(output_folder, "#{time}"))
  unless File.exists?(results_dir)
    Dir.mkdir(results_dir)
    screenshots_dir = File.join(results_dir, "screenshots")
    Dir.mkdir(screenshots_dir)
    errors_dir = File.join(results_dir, "errors")
    Dir.mkdir(errors_dir)
  end

  initialize_logger results_dir

  options[:results_dir] = results_dir
  options[:screenshots_dir] = screenshots_dir
  options[:errors_dir] = errors_dir

  $LOG.info "project environment initialized.".green

end
