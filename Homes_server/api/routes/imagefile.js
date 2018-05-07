var express = require('express');
var router = express.Router();
var multer = require('multer');
var mongoose = require('mongoose');

var Image = mongoose.model('files');
var Home = mongoose.model('homes');
 
router.getImages = function(callback, limit) {
 Image.find(callback).limit(limit);
}
 
 
router.getImageById = function(id, callback) {
 Image.findById(id, callback);
 // Image.find({ homeId: hId }, callback)
}
 
router.addImage = function(image, callback) {
 	Image.create(image, function(err, createdImage) {
 		Home.findOneAndUpdate({_id: image['homeId']}, { "$push": { "images": createdImage._id } }, {new: true}, function(herr, home) {
 			return callback(err, createdImage);
 		});
 	});
}
 
 
// To get more info about 'multer'.. you can go through https://www.npmjs.com/package/multer..
var storage = multer.diskStorage({
 	destination: function(req, file, cb) {
 	cb(null, './public/uploads/')
 },
 	filename: function(req, file, cb) {
 	cb(null, Date.now() + '-' + file.originalname);
 }
});
 
var upload = multer({
 	storage: storage
});
 
router.get('/', function(req, res, next) {
 // res.render('index.js');
});
 
router.post('/', upload.any(), function(req, res, next) {
let formData = req.body;
let hId = formData.homeId;
// res.send(req.files);
/*req.files has the information regarding the file you are uploading...
from the total information, i am just using the path and the imageName to store in the mongo collection(table)
*/
 var path = req.files[0].path;
 path = path.replace('public', '');

 var imageName = req.files[0].originalname;

 var imagepath = {};
 imagepath['path'] = path;
 imagepath['originalname'] = imageName;
 imagepath['homeId'] = hId;
 
 //imagepath contains 3 objects, path, the imageName, homeId
 
 //we are passing 3 objects in the addImage method.. which is defined above..
 router.addImage(imagepath, function(err, image) {
 	if (err) {
 		res.status(200).send(err);
 	} else {
 		res.status(200).send(image);
 	}
 	
 });
 
});
 
module.exports = router;