import Config

if config_env() == :dev do
  import_config "#{config_env()}.exs"
end
