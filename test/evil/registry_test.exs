defmodule EVIL.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    _ = start_supervised!({EVIL.Registry, name: context.test})
    %{registry: context.test}
  end

  test "spawns buckets", %{registry: registry} do
    assert EVIL.Registry.lookup(registry, "shopping") == :error

    EVIL.Registry.create(registry, "shopping")
    assert {:ok, bucket} = EVIL.Registry.lookup(registry, "shopping")

    EVIL.Bucket.put(bucket, "milk", 1)
    assert EVIL.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    EVIL.Registry.create(registry, "shopping")
    {:ok, bucket} = EVIL.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)

    # Do a call to ensure the registry processed the DOWN message
    _ = EVIL.Registry.create(registry, "bogus")
    assert EVIL.Registry.lookup(registry, "shopping") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    EVIL.Registry.create(registry, "shopping")
    {:ok, bucket} = EVIL.Registry.lookup(registry, "shopping")

    # Stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)

    # Do a call to ensure the registry processed the DOWN message
    _ = EVIL.Registry.create(registry, "bogus")
    assert EVIL.Registry.lookup(registry, "shopping") == :error
  end
end
