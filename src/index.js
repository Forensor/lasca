// Imports
const express = require('express');
const socketio = require('socket.io');
const path = require('path');
const bcrypt = require('bcrypt');
const sqlite3 = require('sqlite3').verbose();

// App initialization
const app = express();

// Database
let db = new sqlite3.Database('LASCA', (err) => {
  err ? console.log(err.message) : console.log('DB connected');;
});

db.run(`
  CREATE TABLE IF NOT EXISTS USER (
    id INTEGER PRIMATY KEY AUTOINCREMENT,
    nickname text NOT NULL,
    password text NOT NULL
  )
`, (err) => {
  err ? console.log(err.message) : console.log(`User created: ${this.lastID}`);
});

db.close();

// Settings
app.set('port', process.env.PORT || 3000);

// Static files
app.use(express.static(path.join(__dirname, 'public')));

// Server start
const server = app.listen(app.get('port'), () => {
  console.log(`Server port: ${app.get('port')}`);
});

// IO initialization
const io = socketio.listen(server);

// Routes
app.get('/register', (req, res) => {
  res.json({
    usuario: "mipana",
    password: bcrypt.hashSync('hola', 10)
  });
});

// Websockets
io.on('connection', (socket) => {
  console.log(`Client ${socket.id} connected`);

  socket.on('message', (data) => {
    console.log(data);
    io.sockets.emit('message', data);
  });
});
