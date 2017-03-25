defmodule Chat.Server do
  use GenServer

  @name :chat_server

  def start_link do
    {:ok, pid} = GenServer.start_link(__MODULE__, initial_state(), name: @name)
    :global.register_name(@name, pid)
    {:ok, pid}
  end

  def add_message(message) do
    pid = get_pid()
    GenServer.cast(pid, {:add_message, message})
  end

  def get_messages do
    pid = get_pid()
    GenServer.call(pid, {:get_messages})
  end

  def get_clients do
    pid = get_pid()
    GenServer.call(pid, {:get_clients})
  end

  def get_pid do
    :global.whereis_name(@name)
    # GenServer.whereis(__MODULE__)
  end

  def register_client(client_pid) do
    pid = get_pid()
    GenServer.cast(pid, {:register_client, client_pid})
  end

  # Server

  def initial_state do
    %{clients: [], msgs: []}
  end

  def init(state \\ initial_state()) do
    {:ok, state}
  end

  def handle_cast({:add_message, message}, state) do
    clients = Map.get(state, :clients, [])
    Enum.each clients, fn (client) ->
      send(client, {:new_message, message})
    end

    new_state = Map.update(state, :msgs, [], fn (msgs) -> [message|msgs] end)
    {:noreply, new_state}
  end

  def handle_cast({:register_client, pid}, state) do
    new_state = Map.update(state, :clients, [], fn (pids) -> [pid|pids] end)
    {:noreply, new_state}
  end

  def handle_call({:get_messages}, _from, state) do
    messages = Map.get(state, :msgs, [])
    {:reply, messages, state}
  end

  def handle_call({:get_clients}, _from, state) do
    clients = Map.get(state, :clients, [])
    {:reply, clients, state}
  end
end
