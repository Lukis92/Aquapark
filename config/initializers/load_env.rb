env_file = Rails.root.join('config', 'application.yml')
if env_file.exist?
  config = YAML.safe_load(env_file.read) || {}
  env_vars = config[Rails.env.to_s] || {}
  env_vars.each { |key, value| ENV[key.to_s] ||= value.to_s }
end
