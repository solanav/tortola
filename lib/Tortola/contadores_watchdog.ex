defmodule ContadoresWatchdog do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl true
  def init(_) do
    :timer.send_interval(1000, :check)
    {:ok, %{}}
  end

  @impl true
  def handle_info(:check, state) do
    IO.puts "Checking database for missing entries..."
    {:noreply, state}
  end
end
