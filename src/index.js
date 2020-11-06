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
  let db;
  let user;
  try {
    db = await sqliteAsync.open('LASCA.sqlite3');
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

  if (!user) {
    db.close();
    return done(null, false, req.flash('error', 'That user is not registered'));
  } else {
    if (bcrypt.compareSync(password, user.password)) {
      db.close();
      return done(null, user);
    } else {
      db.close();
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
      username: '',
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

app.get('/@/:username', (req, res) => {
  if (req.isAuthenticated()) {
    res.render('profile', {
      username: req.user.username,
      profile: req.params.username
    });
  } else {
    res.render('profile', {
      username: '',
      profile: req.params.username
    });
  }
});

app.post('/register', async (req, res) => {
  // User register

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

  const validUsername = validateUsername(username);
  const validPassword = validatePassword(password);

  if (registered || !validUsername || !validPassword) {
    if (registered) {
      req.flash('error', 'User already registered');
    } else {
      req.flash('error', 'Invalid password or username');
    }
    res.redirect('/register');
  } else {
    try {
      await db.run(
        'INSERT INTO USER(username, password) VALUES(?, ?)', 
        [username, bcrypt.hashSync(password, 10)]
      );
      console.log(username, 'registered');
      req.flash('success', 'Registration successful!');
      res.redirect('/');
    } catch (err) {
      console.log(err.message);
    }
  }
  db.close();
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
});
