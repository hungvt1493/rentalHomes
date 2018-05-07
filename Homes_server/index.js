var express = require('express'),
  app = express(),
  port = process.env.PORT || 3000,
  mongoose = require('mongoose'),
  Home = require('./api/models/homesModel'), //created model loading here
  Image = require('./api/models/filesModel'),
  bodyParser = require('body-parser');
var session = require('express-session');
var MongoStore = require('connect-mongo')(session);

// mongoose instance connection url connection
mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost/homesdb'); 
var db = mongoose.connection;

//handle mongo error
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function () {
  // we're connected!
});

//use sessions for tracking logins
app.use(session({
  secret: 'work hard',
  resave: true,
  saveUninitialized: false,
  store: new MongoStore({
    mongooseConnection: db
  })
}));

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(express.static('public'));

// include routes
var userRoutes = require('./api/routes/userRoutes');
// app.use('/', userRoutes);
userRoutes(app);


// userRoutes(app);
// app.get('/users', function(req, res) {
// 	userRoutes.getUsers(function(err, genres) {
// 	if (err) {
// 		throw err;
// 	}
// 	res.json(genres); 
// 	});
// });

// image rotues
var imgRoutes = require('./api/routes/imagefile');
app.use('/images', imgRoutes);
 
//URL : http://localhost:3000/images/
// To get all the images/files stored in MongoDB
app.get('/images/all', function(req, res) {
	//calling the function from index.js class using routes object..
	imgRoutes.getImages(function(err, genres) {
	if (err) {
		throw err;
	}
	res.json(genres); 
	});
});
 
// URL : http://localhost:3000/images/(give you collectionID)
// To get the single image/File using id from the MongoDB
app.get('/images/:id', function(req, res) {
	//calling the function from index.js class using routes object..
	imgRoutes.getImageById(req.params.id, function(err, genres) {
	if (err) {
		throw err;
	}
	//res.download(genres.path);
	res.send(genres)
	});
});

var homeRoutes = require('./api/routes/homesRoutes'); //importing route
homeRoutes(app); //register the route



/*
// catch 404 and forward to error handler
app.use(function (req, res, next) {
  var err = new Error('File Not Found');
  err.status = 404;
  next(err);
});

// error handler
// define as the last app.use callback
app.use(function (err, req, res, next) {
  res.status(err.status || 500);
  res.send(err.message);
});
*/

app.listen(port);


console.log('HOMES RESTful API server started on: ' + port);