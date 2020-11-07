const socket = io();

// DOM elements
let onlineUsersDiv= document.getElementById('onlineusers');
const userLogged = document.getElementById('userlogged').innerHTML;

// Aux functions
if (userLogged.length > 0) {
  socket.emit('online', { username: userLogged });
}

// Socket events

socket.on('online', (data) => {
  if (data.username != userLogged) {
    onlineUsersDiv.innerHTML += `<p><a href="/@/${data.username}" title="${data.username}'s user page" id="cusername">${data.username}</a> Invite to play</p>`;
  }
});