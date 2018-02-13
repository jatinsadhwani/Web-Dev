defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game

  def join("games:" <> name, payload, socket) do
    game  = Memory.GameBackup.load(name) || Game.new

    socket = socket
    |> assign(:game,game)
    |> assign(:name,name)

    if authorized?(payload) do
      {:ok, %{"view" => Game.client_view(game)},socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("click", %{"bnumber" => x}, socket) do
    game0 = socket.assigns[:game]
    game1 = Game.buttonClick(game0,x)
    socket = assign(socket, :game, game1)
    {:reply, {:ok, %{"view" => Game.client_view(game1)}}, socket}
  end

  def handle_in("interval", %{"bnumber" => x}, socket) do
    game0 = socket.assigns[:game]
    game1 = Game.intervalClick(game0,x)
    Memory.GameBackup.save(socket.assigns[:name], game1)
    socket = assign(socket, :game, game1)
    {:reply, {:final, %{"view" => Game.client_view(game1)}}, socket}
  end

  def handle_in("refresh", %{}, socket) do
    game0 = socket.assigns[:game]
    game1 = Game.new
    socket = assign(socket, :game, game1)
    {:reply, {:ok, %{"view" => Game.client_view(game1)}}, socket}
  end


  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (games:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
