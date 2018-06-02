defmodule EVIL.Router do
  @doc """
  Dispatch the given `mod`, `fun`, `args` request
  to the approproate node based on the `bucket`.
  """
  def route(bucket, mod, fun, args) do
    first = :binary.first(bucket)

    entry =
      Enum.find(table(), fn {enum, _node} ->
        first in enum end) || no_entry_error(bucket)

    if elem(entry, 1) == node() do
      apply(mod, fun, args)
    else
      {EVIL.RouterTasks, elem(entry, 1)}
      |> Task.Supervisor.async(EVIL.Router, :route, [bucket, mod, fun, args])
      |> Task.await()
    end

  end

  defp no_entry_error(bucket) do
    raise "could not find entry for #{inspect bucket} in table #{inspect table()}"
  end

  @doc """
  Routing table.
  """
  def table do
    Application.fetch_env!(:evil, :routing_table)
  end
end
