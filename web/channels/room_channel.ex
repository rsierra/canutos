defmodule Canutos.RoomChannel do
  use Canutos.Web, :channel
  alias Canutos.Presence

  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      send(self, :after_join)
      {:ok, %{user: socket.assigns.user, users: Presence.list(socket)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user, %{})
    broadcast socket, "new_user", %{user: socket.assigns.user}
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
