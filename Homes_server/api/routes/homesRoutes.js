'use strict';
module.exports = function(app) {
	var homes = require('../controllers/homesController');

	//Routes
	app.route('/homes')
	 .post(homes.createNew)

	app.route('/homes/:page')
	 .get(homes.all)

	app.route('/home/:homeId')
	 .get(homes.getOne)
	 .put(homes.update)
	 .delete(homes.delete)

	// app.route('/homeTags/:searchText')
	//  .get(homes.searchLocationTags)
};