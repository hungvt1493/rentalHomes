'use strict';

var mongoose = require('mongoose'),
Home = mongoose.model('homes'),
Image = mongoose.model('files');

exports.all = function(req, res) {
  var perPage = 20
  var page = req.params.page || 1

  Home.find()
  .sort({createdDate: -1})
  .populate('images')
  .populate('user', 'email username')
  .skip((perPage * page) - perPage)
  .limit(perPage)
  .exec(function(err, homes) {
    if (err) 
      res.send(err);
    res.json(homes);
  });
};


exports.createNew = function(req, res) {
  var new_home = new Home(req.body);
  new_home.save(function(err, home) {
    if (err)
      res.send(err);
    res.json(home);
  });
};


exports.getOne = function(req, res) {
  Home.findById(req.params.homeId)
  .populate('images')
  .populate('user', 'email username')
  .exec(function(err, home) {
    if (err)
      res.send(err);
    res.json(home);
  });
};


exports.update = function(req, res) {
  Home.findOneAndUpdate({_id: req.params.homeId}, req.body, {new: true}, function(err, home) {
    if (err)
      res.send(err);
    res.json(home);
  });
};


exports.delete = function(req, res) {
  Home.remove({
    _id: req.params.homeId
  }, function(err, home) {
    if (err)
      res.send(err);
    res.json({ message: 'Home successfully deleted' });
  });
};

/*
exports.searchLocationTags = function(req, res) {
  //{name: new RegExp(input, "i")
  // Home.find({$text: {$search: req.params.searchText}})
  Home.find({address: new RegExp(req.params.searchText, "i")})
  // .select('address')
  // .sort({createdDate: -1})
  // .limit(20)
  // .lean()
  .distinct('address')
  .exec(function(err, tags) {
    if (err) 
      res.send(err);
    res.json({"tags":tags});

    // var addressList = addresses.map(addresses => addresses.address);
    // res.json({"list": addressList});
  });
};*/