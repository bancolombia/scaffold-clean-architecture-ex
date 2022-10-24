defmodule {app}.Infrastructure.Adapters.UserRepository do
  use {app}.Infrastructure.Adapters.DynamoAdapter, table: "Users", entity: User, id: :email
  # TODO: change table name, entity and id
  # Then you can use:
  # {app}.Infrastructure.Adapters.UserRepository.save(%User{}): {:ok, res} | {:error, reason}
  # {app}.Infrastructure.Adapters.UserRepository.get_by_id(email): {:ok, res} | {:error, reason}
  # {app}.Infrastructure.Adapters.UserRepository.delete_by_id(email): {:ok, res} | {:error, reason}
  # {app}.Infrastructure.Adapters.UserRepository.update_attributes(email, %{some: "property"}): {:ok, res} | {:error, reason}
end
