const socket = io();

// DOM elements
let msg = document.getElementById('msg');
let chat = document.getElementById('cbody');

// Aux functions
const send = () => {
  socket.emit('message', { username: 'admin', message: msg.value });
  msg.value = '';
};

// DOM events
msg.addEventListener('keydown', (evnt) => {
  if (evnt.key === 'Enter') {
    send();
  }
});

// Socket events

socket.on('message', (data) => {
  chat.innerHTML += `<p><a href="users/${data.username}.html" title="${data.username}'s user page" id="cusername">${data.username}</a>: ${data.message}</p>`;
});