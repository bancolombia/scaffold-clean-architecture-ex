defmodule {app}.Utils.CertificatesAdmin do
  @moduledoc false
  require Logger

  def setup() do
    if Code.ensure_loaded?(CAStore) do
      load_certs(System.get_env("EXTRA_CA_CERTS"), CAStore.file_path())
    else
      Logger.warn("Module CAStore is not available to load custom certificates")
    end
  end

  defp load_certs(nil, _destination_file),
       do: Logger.warn("EXTRA_CA_CERTS env variable is not defined to load custom certificates")
  defp load_certs(_pem_files, nil),
       do: Logger.warn("CAStore.file_path() has returned nil to load custom certificates")
  defp load_certs(pem_files, destination_file) do
    with certs <- String.split(pem_files, ","),
         {:ok, output_file} <- File.open(destination_file, [:append])do
      append_all(certs, output_file)
      File.close(output_file)
    else
      error -> Logger.warn("Error loading custom certificates #{inspect(error)}")
    end
  end

  defp append_all(certs, output_file) do
    Enum.each(certs, &(append(&1, output_file)))
  end

  defp append(cert, output_file) do
    case File.read(cert) do
      {:ok, content} -> IO.binwrite(output_file, "\n#{cert}\n===========\n#{content}\n")
      error -> Logger.warn("Error appending custom certificate '#{cert}' #{inspect(error)}")
    end
  end

end
