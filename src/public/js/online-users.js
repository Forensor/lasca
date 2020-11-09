const socket = io();

// DOM elements
let onlineUsersDiv= document.getElementById('onlineusers');
const userLogged = document.getElementById('userlogged').innerHTML;

// Socket events
socket.emit('online', { username: userLogged });

socket.on('online', (data) => {
  onlineUsersDiv.innerHTML = '';
  data.forEach(user => {
    if (user != 'anonymous' && user != userLogged) {
      onlineUsersDiv.innerHTML += `<p><a href="/@/${user}" title="${user}'s user page" id="cusername">${user}</a> Invite to play</p>`;
    }
  });
});