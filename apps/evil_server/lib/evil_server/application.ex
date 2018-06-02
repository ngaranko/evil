defmodule EVILServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Task.Supervisor, name: EVILServer.TaskSupervisor},
      Supervisor.child_spec(
        {Task, fn -> EVILServer.accept(4040) end},
        restart: :permanent)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EVILServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
