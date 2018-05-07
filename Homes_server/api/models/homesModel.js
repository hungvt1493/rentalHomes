'use strict';
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var HomesSchema = new Schema({
	user: {
		type: Schema.Types.ObjectId, 
		ref: 'users' 
	},
	title: {
		type:String,
		required:'Please enter title' 
	},
	desc: {
		type:String,
		required:false 
	},
	createdDate: {
		type: Number,
		default:Date.now()/1000
	},
	status: {
		type:[{
			type: String,
			enum: ['waiting','done']
		}],
		default: 'waiting'
	},
	rentalType: {
		type: Number,
		default: 0
	},
	price: {
		type: Number,
		default: 0
	},
	add1: {
		type:String,
		required:false 
	},
	code1: {
		type:Number,
		required:false 
	},
	add2: {
		type:String,
		required:false 
	},
	code2: {
		type:Number,
		required:false 
	},
	add3: {
		type:String,
		required:false 
	},
	code3: {
		type:Number,
		required:false 
	},
	images: [
		{ 
			type: Schema.Types.ObjectId, 
			ref: 'files' 
		}
	]
});
// .index({
//       'address':'text',
    // });


module.exports = mongoose.model('homes',HomesSchema)