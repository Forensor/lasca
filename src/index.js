// Imports
const express = require('express');
const socketio = require('socket.io');
const path = require('path');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const bcrypt = require('bcrypt');
const sqliteAsync = require('sqlite-async');
const flash = require('connect-flash');
const passport = require('passport');
const cookieParser = require('cookie-parser');
const session = require('express-session');
const LocalStrategy = require('passport-local').Strategy;

// App middlewares
const app = express();
app.use(express.json());
app.use(morgan('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(session({
  secret: 'onlasca',
  resave: false,
  saveUninitialized: false
}));
app.use(passport.initialize());
app.use(passport.session());
app.use(flash());

// Static files
app.use(express.static(path.join(__dirname, 'public')));

// Passport
passport.serializeUser((user, done) => {
  done(null, user.id);
});

passport.deserializeUser(async (id, done) => {
  let db;
  let user;
  try {
    db = await sqliteAsync.open('LASCA.sqlite3');
  } catch (err) {
    console.log(err.message);
  }
  
  try {
    user = await db.get(
      'SELECT * FROM USER WHERE id = ?', 
      [id]
    );
  } catch (err) {
    console.log(err.message);
  }

  db.close();
  done(null, user);
});

passport.use('local-login', new LocalStrategy({
  usernameField: 'username',
  passwordField: 'password',
  passReqToCallback: true
}, async (req, username, password, done) => {
  const user = await userExists(username);

  if (!user) {
    return done(null, false, req.flash('error', 'That user is not registered'));
  } else {
    if (bcrypt.compareSync(password, user.password)) {
      return done(null, user);
    } else {
      return done(null, false, req.flash('error', 'Incorrect password'));
    }
  }
}));

// Settings
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// Aux functions
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
      `
      CREATE TABLE IF NOT EXISTS USER (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        creation_date TEXT NOT NULL,
        online INTEGER NOT NULL
      );
      `
    );
    console.log('TABLE USER ready');
    await db.run(
      `
      CREATE TABLE IF NOT EXISTS GAME (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        white_player INTEGER NOT NULL,
        black_player INTEGER NOT NULL,
        date TEXT NOT NULL,
        pgn TEXT,
        fen TEXT NOT NULL,
        turn INTEGER NOT NULL,
        winner INTEGER NOT NULL,
        FOREIGN KEY (white_player) REFERENCES USER(id),
        FOREIGN KEY (black_player) REFERENCES USER(id)
      );
      `
    );
    console.log('TABLE GAME ready');
    await db.run(
      `
      CREATE TABLE IF NOT EXISTS MESSAGE (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user INTEGER NOT NULL,
        game INTEGER NOT NULL,
        date TEXT NOT NULL,
        message_text TEXT NOT NULL,
        FOREIGN KEY (user) REFERENCES USER(id),
        FOREIGN KEY (game) REFERENCES GAME(id)
      );
      `
    );
    console.log('TABLE MESSAGE ready');
  } catch (err) {
    console.log(err.message);
  }
  
  console.log('DB operational');
  db.close();
};

const validateUsername = (username) => {
  const valid = new RegExp('^(?=.{4,15}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$');

  if (valid.test(username)) {
    return true;
  }

  return false;
}

const validatePassword = (password) => {
  const valid = new RegExp('^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])*.{8,24}$');
  
  if (valid.test(password)) {
    return true;
  }

  return false;
};

const userExists = async (username) => {
  let db;
  let user;
  try {
    db = await sqliteAsync.open('LASCA.sqlite3');
    console.log('DB LASCA ready');
  } catch (err) {
    console.log(err.message);
  }
  try {
    user = await db.get(
      'SELECT * FROM USER WHERE username = ?', 
      [username]
    );
  } catch (err) {
    console.log(err.message);
  }

  db.close();

  if (user) {
    return user;
  } else {
    return false;
  }
};

const updateUserConnectionStatus = async (username, status) => {
  let db;
  try {
    db = await sqliteAsync.open('LASCA.sqlite3');
  } catch (err) {
    console.log(err.message);
  }
  try {
    await db.run(
      'UPDATE USER SET online = ? WHERE username = ?', 
      [status, username]
    );
  } catch (err) {
    console.log(err.message);
  }

  db.close();
};

const getOnlineUsers = async () => {
  let db;
  let users;
  try {
    db = await sqliteAsync.open('LASCA.sqlite3');
  } catch (err) {
    console.log(err.message);
  }
  try {
    users = await db.all(
      'SELECT * FROM USER WHERE online = 1'
    );
  } catch (err) {
    console.log(err.message);
  }

  db.close();
  const usernames = users.map(u => u.username);

  return usernames;
};

const insertNewUser = async (username, password) => {
  let db;
  try {
    db = await sqliteAsync.open('LASCA.sqlite3');
  } catch (err) {
    console.log(err.message);
  }
  let d = new Date();
  let date = `${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()} ${d.getHours()}:${d.getMinutes()}:${d.getSeconds()}.${d.getMilliseconds()}`;
  try {
    await db.run(
      'INSERT INTO USER(username, password, creation_date, online) VALUES(?, ?, ?, ?)', 
      [username, bcrypt.hashSync(password, 10), date, 0]
    );
  } catch (err) {
    console.log(err);
  }
  db.close();
};

const createNewGame = async (white, black) => {
  let db;
  let id;
  try {
    db = await sqliteAsync.open('LASCA.sqlite3');
  } catch (err) {
    console.log(err.message);
  }
  let d = new Date();
  let date = `${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()} ${d.getHours()}:${d.getMinutes()}:${d.getSeconds()}.${d.getMilliseconds()}`;
  try {
    let whiteID = await db.get('SELECT id FROM USER WHERE username = ?', [white]);
    let blackID = await db.get('SELECT id FROM USER WHERE username = ?', [black]);
    await db.run(
      'INSERT INTO GAME(white_player, black_player, date, fen, turn, winner) VALUES(?, ?, ?, ?, ?, ?)', 
      [whiteID.id, blackID.id, date, 'bbbb/bbb/bbbb/3/wwww/www/wwww', 1, 0]
    );
    id = await db.get(
      'SELECT id FROM GAME WHERE date = ?', 
      [date]
    );
  } catch (err) {
    console.log(err);
  }

  db.close();
  return id.id;
};

const getGameInfo = async (id) => {
  let db;
  let game;
  let white;
  let black;
  try {
    db = await sqliteAsync.open('LASCA.sqlite3');
  } catch (err) {
    console.log(err.message);
  }
  try {
    game = await db.get(
      'SELECT * FROM GAME WHERE id = ?', 
      [id]
    );
  } catch (err) {
    console.log(err.message);
  }
  try {
    white = await db.get(
      'SELECT * FROM USER WHERE id = ?', 
      [game.white_player]
    );
  } catch (err) {
    console.log(err.message);
  }
  try {
    black = await db.get(
      'SELECT * FROM USER WHERE id = ?', 
      [game.black_player]
    );
  } catch (err) {
    console.log(err.message);
  }

  db.close();

  return { id: game.id, whitep: white.username, blackp: black.username, pgn: game.pgn, fen: game.fen, turn: game.turn, winner: game.winner };
};

// Database
databaseCreation();

// Server start
const server = app.listen(app.get('port'), () => {
  console.log('Server port:', app.get('port'));
});

// IO initialization
const io = socketio.listen(server);

// Routes
app.get('/', (req, res) => {
  if (req.isAuthenticated()) {
    res.render('index', {
      username: req.user.username,
      message: ''
    });
  } else {
    res.render('index', { 
      username: 'anonymous',
      message: req.flash('success')
    });
  }
});

app.get('/register', (req, res) => {
  if (req.isAuthenticated()) {
    res.redirect('/');
  } else {
    res.render('register', {
      message: req.flash('error')
    });
  }
});

app.get('/login', (req, res) => {
  if (req.isAuthenticated()) {
    res.redirect('/');
  } else {
    res.render('login', {
      message: req.flash('error')
    });
  }
});

app.get('/g/:gameid', (req, res) => {
  if (req.isAuthenticated()) {
    res.render('game', {
      username: req.user.username,
      id: req.params.gameid
    });
  } else {
    res.render('game', { 
      username: 'anonymous', 
      id: req.params.gameid 
    });
  }
});

app.get('/@/:username', async (req, res) => {
  if (await userExists(req.params.username)) {
    if (req.isAuthenticated()) {
      res.render('profile', {
        username: req.user.username,
        profile: req.params.username
      });
    } else {
      res.render('profile', {
        username: 'anonymous',
        profile: req.params.username
      });
    }
  } else {
    res.redirect('/');
  }
});

app.post('/register', async (req, res) => {
  const registered = await userExists(req.body.username);
  const validUsername = validateUsername(req.body.username);
  const validPassword = validatePassword(req.body.password);

  if (registered || !validUsername || !validPassword) {
    if (registered) {
      req.flash('error', 'User already registered');
    } else {
      req.flash('error', 'Invalid password or username');
    }
    res.redirect('/register');
  } else {
    try {
      await insertNewUser(req.body.username, req.body.password);
      console.log(req.body.username, 'registered');
      req.flash('success', 'Registration successful!');
      res.redirect('/');
    } catch (err) {
      console.log(err.message);
    }
  }
});

app.post('/login', passport.authenticate('local-login', {
  successRedirect: '/',
  failureRedirect: '/login',
  failureFlash: true
}));

app.get('/logout', (req, res) => {
  req.logOut();
  res.redirect('/');
});

// Websockets
io.on('connection', (socket) => {
  console.log('Client', socket.id, 'connected');

  socket.on('message', (data) => {
    io.sockets.emit('message', data);
  });

  socket.on('invitation', (data) => {
    io.sockets.emit('invitation', data);
  });

  socket.on('create-game', async (data) => {
    const players = [data.inviting, data.invited];
    const white = players[Math.floor(Math.random() * players.length)];
    const black = players.filter(p => p !== white)[0];
    const gameID = await createNewGame(white, black);

    io.sockets.emit('create-game', { id: gameID });
  });

  socket.on('online', async (data) => {
    updateUserConnectionStatus(data.username, 1);
    io.sockets.emit('online', await getOnlineUsers());

    socket.on('disconnect', () => {
      updateUserConnectionStatus(data.username, 0);
    });
  });

  socket.on('game-room', async (data) => {
    io.sockets.emit('game-room', await getGameInfo(data.id));
  });
});
