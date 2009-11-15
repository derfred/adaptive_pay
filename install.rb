config_path = File.join('config', 'adaptive_pay.yml')
unless File.exist?(File.join(RAILS_ROOT, config_path))
  FileUtils.cp File.join(File.dirname(__FILE__), config_path), File.join(RAILS_ROOT, config_path)
end
