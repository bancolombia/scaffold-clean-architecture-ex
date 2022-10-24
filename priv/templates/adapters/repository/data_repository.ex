defmodule {app}.Infrastructure.Adapters.Repository.{name}.{name}DataRepository do
  alias {app}.Infrastructure.Adapters.Repository.Repo
  alias {app}.Infrastructure.Adapters.Repository.{name}.Data.{name}Data
  # alias {app}.Domain.Model.{name}

  ## TODO: Update behaviour
  # @behaviour {app}.Domain.Behaviours.{name}Behaviour

  def find_by_id(id), do: {name}Data |> Repo.get(id) |> to_entity

  def insert(entity) do
    case to_data(entity) |> Repo.insert do
      {:ok, entity} -> entity |> to_entity()
      error -> error
    end
  end

  defp to_entity(nil), do: nil
  defp to_entity(data) do
    ## TODO: Update Entity
    # struct({name}, data |> Map.from_struct)
    %{}
  end

  defp to_data(entity) do
    struct({name}Data, entity |> Map.from_struct)
  end
end
