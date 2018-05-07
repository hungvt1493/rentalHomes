'use strict';

module.exports = function(app) {
  var users = require('../controllers/usersController');

  //Routes
  app.route('/users/all')
   .get(users.getAllUsers)

  app.route('/users/profile/:userId')
   .get(users.getUserById)

  app.route('/users/myprofile')
   .get(users.getMyProfile)

  app.route('/login')
   .post(users.login)

  app.route('/register')
   .post(users.regUser)

  app.route('/logout')
   .get(users.logout)
};


/*
var express = require('express');
var router = express.Router();
var User = require('../models/userModel');


// GET route for reading data
router.get('/users', function (req, res, next) {
  return res.json({"error":0});
});

router.get('/users/all', function (req, res, next) {
  User.find().exec(function(err, users) {
    if (err) 
      return res.send(err);
    return res.json(users);
  });
});

//POST route for updating data
router.post('/users', function (req, res, next) {
  if (req.body.email &&
    req.body.username &&
    req.body.password) {

    var userData = {
      email: req.body.email,
      username: req.body.username,
      password: req.body.password
    }

    User.create(userData, function (error, user) {
      if (error) {
        if (error.code === 11000) {
        // Duplicate username
          return res.status(500).send({ succes: false, message: 'Email already exist!' });
        }
        return res.status(500).send(error);
      } else {
        req.session.userId = user._id;
        return res.redirect('/users/myprofile');
      }
    });

  } else if (req.body.logemail && req.body.logpassword) {
    User.authenticate(req.body.logemail, req.body.logpassword, function (error, user) {
      if (error || !user) {
        return res.status(401).json({"_id":"", "error":"Wrong email or password."})
      } else {
        req.session.userId = user._id;
        // return res.redirect('/users/myprofile');
        return res.json(user)
      }
    });
  } else {
    return res.status(400).json({"_id":"", "error":"All fields required."})
  }
})

// GET route after registering
router.get('/users/myprofile', function (req, res, next) {
  User.findById(req.session.userId)
    .exec(function (error, user) {
      if (error) {
        return next(error);
      } else {
        if (user === null) {
          return res.status(400).json({"_id":"", "error":"Not authorized! Go back!"})
        } else {
          return res.json(user)
        }
      }
    });
});

// GET for logout logout
router.get('/users/logout', function (req, res, next) {
  if (req.session) {
    // delete session object
    req.session.destroy(function (err) {
      if (err) {
        return next(err);
      } else {
        return res.json({"error":0}); //res.redirect('/users');
      }
    });
  }
});

router.get('/users/profile/:userId', function (req, res, next) {
  User.findById(req.params.userId)
    .exec(function (error, user) {
      if (error) {
        return next(error);
      } else {
        if (user === null) {
          return res.status(400).json({"_id":"", "error":"Not Found"})
        } else {
          return res.json(user);
        }
      }
    });
});
module.exports = router;
*/