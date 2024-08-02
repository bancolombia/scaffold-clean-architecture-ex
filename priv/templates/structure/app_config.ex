defmodule {app}.Config.AppConfig do

  @moduledoc """
   Provides strcut for app-config
  """

   defstruct [
     :env,
     :enable_server,
     :http_port
     # TODO: Add your config properties here
   ]

   def load_config do
     %__MODULE__{
       env: load(:env),
       enable_server: load(:enable_server),
       http_port: load(:http_port)
       # TODO: Load your config properties here
     }
   end

   defp load(property_name), do: Application.fetch_env!(:{app_snake}, property_name)
 end
