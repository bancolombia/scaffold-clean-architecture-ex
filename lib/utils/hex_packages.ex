defmodule ElixirStructureManager.Utils.Hex.Packages do
  @moduledoc """
  Module to manage dependencies in mix.exs
  """

  @doc """
  Updates dependencies in mix.exs to their latest versions from hex.pm
  """

  def get_stable_version(package) do
    url = "#{System.get_env("HEX_API_ENDPOINT", "https://hex.pm/api")}/packages/#{package}"

    http_options = [{:ssl, ssl_options()}]

    case :httpc.request(
           :get,
           {url, [{~c"User-Agent", "Elixir/#{System.version()}"}]},
           http_options,
           []
         ) do
      {_, {{_status, 200, _}, _headers, body}} ->
        process_response_body(body)

      {_, {{_status, http_status, reason}, _headers, _}} ->
        log_error("Request failed with status code #{http_status} #{reason}")

      {:error, reason} ->
        log_error("Request failed with error #{inspect(reason)}")
    end
  end

  defp process_response_body(body) do
    case Poison.decode(body) do
      {:ok, %{"latest_stable_version" => version, "configs" => %{"mix.exs" => config}}} ->
        {:ok, {version, config}}

      _ ->
        log_error("Failed to parse response #{inspect(body)}")
    end
  end

  defp ssl_options do
    if System.get_env("HEX_UNSAFE_HTTPS") == "1" || System.get_env("HEX_UNSAFE_REGISTRY") == "1" do
      [{:verify, :verify_none}]
    else
      file = System.get_env("HEX_CACERTS_PATH")

      if file != nil && File.exists?(file) do
        [{:cacertfile, file}]
      else
        []
      end
    end
  end

  defp log_error(msg) do
    Mix.shell().error(msg)
    {:error, msg}
  end
end
