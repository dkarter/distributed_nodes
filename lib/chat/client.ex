defmodule Chat.Client do
  alias Chat.Server

  def start do
    client_pid = spawn(__MODULE__, :listen_to_messages, [])
    Server.register_client(client_pid)
  end

  def listen_to_messages do
    receive do
      {:new_message, msg} ->
        IO.inspect(msg, label: "client got message")
        listen_to_messages()
    end
  end

end
