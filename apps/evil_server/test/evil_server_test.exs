defmodule EVILServerTest do
  use ExUnit.Case
  doctest EVILServer

  test "greets the world" do
    assert EVILServer.hello() == :world
  end
end
