express = require('express')
connect = require('connect')
app = express.createServer()
_ = require('underscore')
BundleUp = require('bundle-up')
lookup = require('./lookup.js')
mailer = require('./mailer.js')
fs = require('fs')
nib = require('nib')
stylus = require('stylus')


# compile = (str, path) ->
# 	stylus(str).set('filename', path).set('compress', true).use nib()

app.use stylus.middleware
	src: __dirname + '/public'
	compile: (str, path) ->
		stylus(str).set('filename', path).set('warn', true).set('compress', true).use(nib())

# app.use stylus.middleware
# 	src: __dirname + '/public/styl'
# 	# dest: __dirname + 'public/css'
# 	compile: compile

# Change
#
# Express config
app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.set('view options', { layout: false })

app.use(express.cookieParser())
#app.use(connect.compress())
app.use(express.static(__dirname + '/public'))
app.use(express.bodyParser())

DEV_PORT = 3000
PROD_PORT = 80
IS_PRODUCTION = (process.env.NODE_ENV == 'production')

# Minification
console.log 'Bundling....'

BundleUp app, __dirname + '/assets', {
	staticRoot    : __dirname + '/public/'
	staticUrlRoot : '/'
	bundle        : IS_PRODUCTION
	minifyCss     : false
	minifyJs      : false
}

console.log 'Finished bundling'

# Routing
app.get '/', (req, res) ->
	# homepage with special args and top ranking data
	lookup.homepage (err, summary_result) ->
		renderWithContext res, 'index', {
			nosocial: req.query.nosocial != undefined,
			summary: summary_result,
		}

app.get '/top', (req, res) ->
	fs.readFile 'top.json', (err, data) ->
		res.send JSON.parse(data)

app.get '/top-targets', (req, res) ->
	fs.readFile 'json/targets.json', (err, data) ->
		res.send JSON.parse(data)

renderWithContext = (res, template, obj) ->
	# Add a global context to all templates
	obj = {} if (!obj)
	obj.context = {
		layout: 'layout',
		production: IS_PRODUCTION,
	}
	res.render template, obj

# Start server
if process.env.PORT
	port = process.env.PORT
else
	port = DEV_PORT
	port = PROD_PORT if IS_PRODUCTION
app.listen port

console.log 'Running in context:', process.env.NODE_ENV
console.log 'Started listening on port ' + port
