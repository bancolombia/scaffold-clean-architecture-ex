defmodule {app}.Adapters.DynamoAdapter do
  defmacro __using__(mod_opts) do
    quote do
      alias ExAws.Dynamo
      alias ExAws.Dynamo.Encodable

      @module unquote(mod_opts[:entity])
      @table unquote(mod_opts[:table])
      @id unquote(mod_opts[:id] || :id)

      def save(item) do
        Dynamo.put_item(@table, item)
        |> ExAws.request()
      end

      def get_by_id(id) do
        Dynamo.get_item(@table, build_id(id))
        |> ExAws.request()
        |> decode()
      end

      def update_attributes(id, attr) do
        Dynamo.update_item(@table, build_id(id), build_update_options(attr))
        |> ExAws.request()
      end

      def delete_by_id(id) do
        Dynamo.delete_item(@table, build_id(id))
        |> ExAws.request()
        |> decode()
      end

      defp decode({:ok, result}) when result == %{}, do: {:error, :not_found}

      defp decode({:ok, %{"Item" => _item} = result}),
        do: {:ok, Dynamo.decode_item(result, as: @module)}

      defp decode(other), do: other

      defp build_id(id), do: [{@id, id}]

      defp build_update_options(attr) do
        {expression, arguments} =
          Map.keys(struct(@module))
          |> Enum.filter(&Map.has_key?(attr, &1))
          |> Enum.reduce({[], %{}}, fn key, {exp, args} ->
            {["#{key} = :#{key}" | exp], Map.put(args, key, attr[key])}
          end)

        [
          update_expression: "SET " <> Enum.join(expression, " ,"),
          expression_attribute_values: arguments
        ]
      end
    end
  end
end
