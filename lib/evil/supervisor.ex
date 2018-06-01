defmodule EVIL.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {DynamicSupervisor, name: EVIL.BucketSupervisor, strategy: :one_for_one},
      {EVIL.Registry, name: EVIL.Registry}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
