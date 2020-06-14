defmodule Tortola.Database.Queries do
  use GenServer

  @dbusername "admin"
  @dbpassword "***"
  @dbhost "192.168.1.120"
  @dbport 3306
  @dbname "testing"

  # Client

  def start() do
    GenServer.start_link(__MODULE__, nil)
  end

  @impl true
  def init(_) do
    {:ok, conn} = MyXQL.start_link(username: @dbusername, password: @dbpassword, hostname: @dbhost, port: @dbport, database: @dbname)
    {:ok, conn}
  end

  def test_query(pid) do
    GenServer.call(pid, :test)
  end

  def test_insert(pid) do
    GenServer.call(pid, :insert_test)
  end

  # Server

  @impl true
  def handle_call(:test, _from, conn) do
    {:reply, MyXQL.query(conn, "SELECT NOW()"), conn}
  end

  @impl true
  def handle_call(:insert_test, _from, conn) do
    {:reply, MyXQL.query(conn, "INSERT INTO testing.test (col) VALUES (1)"), conn}
  end
end
