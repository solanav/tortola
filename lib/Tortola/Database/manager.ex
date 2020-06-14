defmodule Tortola.Database.Manager do
  use GenServer

  @maxconn 10

  # Client

  @impl true
  def init(_) do
    conn_list = Enum.reduce(0..@maxconn, %{}, fn x, acc ->
      Map.put(acc, x, create_conn())
    end)

    {:ok, conn_list}
  end

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def get_conn do
    GenServer.call(__MODULE__, {:get_conn, :rand.uniform(10) - 1})
  end

  # Server

  @impl true
  def handle_call({:get_conn, id}, _from, state) do
    {:reply, state[id], state}
  end

  defp create_conn do
    {:ok, pid} = Tortola.Database.Queries.start()
    pid
  end
end
