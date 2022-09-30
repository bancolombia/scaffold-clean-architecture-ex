defmodule User do
  # Sample model that will be persisted in dynamo, it should have the next @derive attribute
  @derive [ExAws.Dynamo.Encodable]
  defstruct [:email, :user_name, :age, :admin]

  def new(email, user_name, age, admin) do
    %__MODULE__{email: email, user_name: user_name, age: age, admin: admin}
  end
end
