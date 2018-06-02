defmodule EVIL.RouterTest do
  use ExUnit.Case, async: true

  @tag :distributed
  test "route requests across nodes" do
    assert EVIL.Router.route("hello", Kernel, :node, []) ==
      :"foo@nicks-mac-pro-2"
    assert EVIL.Router.route("whello", Kernel, :node, []) ==
      :"bar@nicks-mac-pro-2"
  end

  test "raises on unknown entries" do
    assert_raise RuntimeError, ~r/could not find entry/, fn ->
      EVIL.Router.route(<<0>>, Kernel, :node, [])
    end
  end
end
