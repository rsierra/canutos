let Room = {
  init(socket) {
    let channel = socket.channel("room:lobby", {})
    let users_list = $('#users-list')

    channel.join()
      .receive("ok", resp => {
        console.log("Joined successfully", resp);
        $('#current-user').html(resp.user)
        $.each( resp.users, function( key, value ) {
          users_list.append(`<li>${key}</li>`)
        })
      })
      .receive("error", resp => { console.log("Unable to join", resp); })

    channel.on("new_user", payload => {
      users_list.append(`<li>${payload.user}</li>`)
    })
  }
}

export default Room;