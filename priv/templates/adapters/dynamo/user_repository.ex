defmodule {app}.Adapters.UserRepository do
  use {app}.Adapters.DynamoAdapter, table: "Users", entity: User, id: :email
  # TODO: change table name, entity and id
  # Then you can use:
  # {app}.Adapters.UserRepository.save(%User{}): {:ok, res} | {:error, reason}
  # {app}.Adapters.UserRepository.get_by_id(email): {:ok, res} | {:error, reason}
  # {app}.Adapters.UserRepository.delete_by_id(email): {:ok, res} | {:error, reason}
  # {app}.Adapters.UserRepository.update_attributes(email, %{some: "property"}): {:ok, res} | {:error, reason}
end
