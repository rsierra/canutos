let Room = {
  init(socket) {
    let channel = socket.channel("room:lobby", {})

    channel.join()
      .receive("ok", resp => {
        console.log("Joined successfully", resp);
        $('#current-user').html(resp.user)
      })
      .receive("error", resp => { console.log("Unable to join", resp); })
  }
}

export default Room;