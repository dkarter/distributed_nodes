defmodule Chat.ServerTest do
  use ExUnit.Case, async: true
  alias Chat.Server

  test "starts up with no messages" do
    {:ok, _} = Server.start_link
    assert Server.get_messages() == []
  end

  test "can add a message" do
    {:ok, _} = Server.start_link
    Server.add_message("hello world")
    Server.add_message("it works")
    assert Server.get_messages() == ["it works", "hello world"]
  end

  test "gets pid of server" do
    {:ok, pid} = Server.start_link
    assert Server.get_pid() == pid
  end

  test "can register clients" do
    Server.start_link
    client_pid = spawn(fn -> nil end)
    Server.register_client(client_pid)
    assert Server.get_clients() == [client_pid]
  end
end
