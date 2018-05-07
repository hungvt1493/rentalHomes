'use strict';

var mongoose = require('mongoose');
// User = mongoose.model('users');
var User = require('../models/userModel');

exports.getAllUsers = function(req, res) {
	User.find()
	.select('username email')
	.exec(function(err, users) {
    	if (err) 
      		res.send(err);
    	res.json(users);
	});
};

exports.getUserById = function(req, res) {
	User.findById(req.params.userId)
	.select('username email')
    .exec(function (error, user) {
      if (error) {
        // return next(error);
        res.send(error);
      } else {
        if (user === null) {
          res.status(400).json({message:"Not Found"})
        } else {
          res.json(user);
        }
      }
    });
};

exports.getMyProfile = function(req, res) {
	User.findById(req.session.userId)
	.select('username email')
    .exec(function (error, user) {
      if (error) {
        // return next(error);
        res.send(error);
      } else {
        if (user === null) {
          res.status(400).json({message:"Not authorized! Go back!"})
        } else {
          res.json(user)
        }
      }
    });
};

exports.regUser = function(req, res) {
    var userData = req.body;

    User.create(userData, function (error, user) {
      if (error) {
        if (error.code === 11000) {
        // Duplicate username
          	res.status(500).send({ succes: false, message: 'Email already exist!' });
        } else {
        	res.status(500).send(error);
        }
      } else {
        req.session.userId = user._id;
        res.redirect('/users/myprofile');
      }
    });
};

exports.login = function(req, res) {
	User.authenticate(req.body.email, req.body.password, function (error, user) {
      if (error || !user) {
        res.status(401).json({message:"Wrong email or password."});
      } else {
        req.session.userId = user._id;
        res.json(user);
      }
    });
};

exports.logout = function(req, res) {
	if (req.session) {
    // delete session object
    req.session.destroy(function (err) {
      if (err) {
        // return next(err);
        res.send(err);
      } else {
        res.json({"error":0}); //res.redirect('/users');
      }
    });
  }
};