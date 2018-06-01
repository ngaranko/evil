defmodule EVIL.BucketTest do
  use ExUnit.Case, async: true

  setup do
    bucket = start_supervised!(EVIL.Bucket)
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert EVIL.Bucket.get(bucket, "milk") == nil

    EVIL.Bucket.put(bucket, "milk", 3)
    assert EVIL.Bucket.get(bucket, "milk") == 3
  end

  test "stores and removes values", %{bucket: bucket} do
    EVIL.Bucket.put(bucket, "milk", 3)
    assert EVIL.Bucket.get(bucket, "milk") == 3

    EVIL.Bucket.delete(bucket, "milk")
    assert EVIL.Bucket.get(bucket, "milk") == nil
  end

  test "removing notexisting item", %{bucket: bucket} do
    EVIL.Bucket.delete(bucket, "milk")
  end

  test "are temporary workers" do
    assert Supervisor.child_spec(EVIL.Bucket, []).restart == :temporary
  end
end
