defmodule {app}.Infrastructure.EntryPoint.AsyncMessageHandlers do
  @moduledoc false

  def setup()  do
    %HandlersConfig{}
    #    # Define your own subscriptions
    #    HandlerRegistry.serve_query("GetPerson", &SomeUseCaseModule.get_person/1) # serve a query, should pass query_name and the function which will handle the request.
    #    |> HandlerRegistry.handle_command("RegisterPerson", &SomeUseCaseModule.register_person/1) # listen for a command, should pass command_name and the function which will handle the command.
    #    |> HandlerRegistry.listen_event("PersonRegistered", &SomeUseCaseModule.person_registered/1)
  end
end
