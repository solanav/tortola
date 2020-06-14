defmodule Tortola do
  use

  alias Tortola.Database, as: DB

  @moduledoc false
  def main do
    children = [
      ContadoresWatchdog
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
