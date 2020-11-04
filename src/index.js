// Imports
const express = require('express');
const socketio = require('socket.io');
const path = require('path');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const bcrypt = require('bcrypt');
const sqliteAsync = require('sqlite-async');

// App initialization
const app = express();
app.use(express.json());
app.use(morgan('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Database
const databaseCreation = async () => {
  let db;
  try {
    db = await sqliteAsync.open('LASCA.sqlite3');
    console.log('DB LASCA ready');
  } catch (err) {
    console.log(err.message);
  }
  
  try {
    await db.run(
      `CREATE TABLE IF NOT EXISTS USER (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )`
    );
    console.log('TABLE USER ready');
  } catch (err) {
    console.log(err.message);
  }
  
  console.log('DB operational, closing now...');
  db.close();
};

databaseCreation();

// Settings
app.set('port', process.env.PORT || 3000);

// Static files
app.use(express.static(path.join(__dirname, 'public')));

// Server start
const server = app.listen(app.get('port'), () => {
  console.log('Server port:', app.get('port'));
});

// IO initialization
const io = socketio.listen(server);

// Routes
app.post('/ur', async (req, res) => {
  let db;
  let registered;
  const username = req.body.username;
  const password = req.body.password;
  try {
    db = await sqliteAsync.open('LASCA.sqlite3');
  } catch (err) {
    console.log(err.message);
  }
  try {
    registered = await db.get(
      'SELECT * FROM USER WHERE username = ?', 
      [username]
    );
  } catch (err) {
    console.log(err.message);
  }

  res.redirect('/');

  if (registered) {
    console.log('User already registered');
  } else {
    try {
      await db.run(
        'INSERT INTO USER(username, password) VALUES(?, ?)', 
        [username, bcrypt.hashSync(password, 10)]
      );
      console.log(username, 'registered');
    } catch (err) {
      console.log(err.message);
    }
  }
  db.close();
});

// Websockets
io.on('connection', (socket) => {
  console.log('Client', socket.id, 'connected');

  socket.on('message', (data) => {
    console.log(data);
    io.sockets.emit('message', data);
  });
});
