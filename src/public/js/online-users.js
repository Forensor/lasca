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
      if (userLogged != 'anonymous') {
        onlineUsersDiv.innerHTML += `<p><a href="/@/${user}" title="${user}'s user page" id="cusername">${user}</a> <button id="invitation-${user}">Invite to play</button></p>`;
        let ele = document.getElementById(`invitation-${user}`);
        ele.addEventListener('click', () => {
          socket.emit('invitation', { inviting: userLogged, invited: user });
        });
      } else {
        onlineUsersDiv.innerHTML += `<p><a href="/@/${user}" title="${user}'s user page" id="cusername">${user}</a></p>`;
      }
      
    }
  });
});

socket.on('invitation', (data) => {
  if (data.invited == userLogged) {
    document.getElementById('invitations').innerHTML += `${data.inviting} invited you to play <button id="accept-${data.inviting}">Accept</button>`;
    let ele = document.getElementById(`accept-${data.inviting}`);
    ele.addEventListener('click', () => {
      socket.emit('create-game', data);
    });
  }
});

socket.on('create-game', (data) => {
  console.log(data);
  window.location.replace(`${window.location.href}g/${data.id}`);
});