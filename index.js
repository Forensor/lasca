const express = require('express');
const path = require('path');
const app = express();

const socketio = require('socket.io');

// Settings
app.set('port', process.env.PORT || 3000);

// Static files
app.use(express.static(path.join(__dirname, 'public')));

// Server start
const server = app.listen(app.get('port'), () => {
  console.log(`Server port: ${app.get('port')}`);
});

const io = socketio.listen(server);

// Websockets
io.on('connection', (socket) => {
  console.log(`Client ${socket.id} connected`);

  socket.on('message', (data) => {
    console.log(data);
    io.sockets.emit('message', data);
  });
});
