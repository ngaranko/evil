defmodule EVIL do
  use Application
  def start(_type, _args) do
    EVIL.Supervisor.start_link(name: EVIL.Supervisor)
  end
end
