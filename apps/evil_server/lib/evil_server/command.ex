defmodule EVILServer.Command do
  @doc ~S"""
  Passes the given `line` into command.

  ## Examples

    iex> EVILServer.Command.parse "CREATE test\r\n"
    {:ok, {:create, "test"}}

    iex> EVILServer.Command.parse "CREATE test \r\n"
    {:ok, {:create, "test"}}

    iex> EVILServer.Command.parse "PUT test whoo 1\r\n"
    {:ok, {:put, "test", "whoo", "1"}}

    iex> EVILServer.Command.parse "GET test whoo\r\n"
    {:ok, {:get, "test", "whoo"}}

    iex> EVILServer.Command.parse "DELETE test meh\r\n"
    {:ok, {:delete, "test", "meh"}}

  Unknown commands or commands with the wrong number of
  arguments return an error:

    iex> EVILServer.Command.parse "UNKNOWN shopping eggs\r\n"
    {:error, :unknown_command}

    iex> EVILServer.Command.parse "GET shopping\r\n"
    {:error, :unknown_command}
  """
  def parse(line) do
    case String.split(line) do
      ["CREATE", bucket] -> {:ok, {:create, bucket}}
      ["GET", bucket, key] -> {:ok, {:get, bucket, key}}
      ["PUT", bucket, key, value] -> {:ok, {:put, bucket, key, value}}
      ["DELETE", bucket, key] -> {:ok, {:delete, bucket, key}}
      _ -> {:error, :unknown_command}
    end
  end

  @doc """
  Runs the given command.
  """
  def run(command)

  def run({:create, bucket}) do
    EVIL.Registry.create(EVIL.Registry, bucket)
    {:ok, "OK\r\n"}
  end

  def run({:get, bucket, key}) do

    lookup(bucket, fn pid ->
      value = EVIL.Bucket.get(pid, key)
      {:ok, "#{value}\r\nOK\r\n"}
    end)
  end

  def run({:put, bucket, key, value}) do

    lookup(bucket, fn pid ->
      EVIL.Bucket.put(pid, key, value)
      {:ok, "OK\r\n"}
    end)
  end

  def run({:delete, bucket, key}) do
    lookup(bucket, fn pid ->
      EVIL.Bucket.delete(pid, key)
      {:ok, "OK\r\n"}
    end)
  end

  defp lookup(bucket, callback) do
    case EVIL.Registry.lookup(EVIL.Registry, bucket) do
      {:ok, pid} -> callback.(pid)
      :error -> {:error, :not_found}
    end
  end

end
