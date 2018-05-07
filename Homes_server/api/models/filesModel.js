'use strict';

var mongoose = require('mongoose');

var ImageSchema = mongoose.Schema({
 	path: {
 		type: String,
 		required: true,
 		trim: true
 	},
 	originalname: {
 		type: String,
 		required: true
 	},
 	homeId: {
 		type: String,
 		required: true
 	}
});

module.exports = mongoose.model('files',ImageSchema)