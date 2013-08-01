express = require('express')
connect = require('connect')
app = express.createServer()
fs = require('fs')
nib = require('nib')
stylus = require('stylus')

app.use stylus.middleware
	src: __dirname + '/public'
	compile: (str, path) ->
		stylus(str).set('filename', path).set('warn', true).set('compress', true).use(nib())

app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.set('view options', { layout: false })

app.use(express.cookieParser())
app.use(express.static(__dirname + '/public'))
app.use(express.bodyParser())

DEV_PORT = 3000
PROD_PORT = 80
IS_PRODUCTION = (process.env.NODE_ENV == 'production')

# Routing
app.get '/', (req, res) ->
	res.render 'index'

app.get '/top', (req, res) ->
	fs.readFile 'top.json', (err, data) ->
		res.send JSON.parse(data)

app.get '/top-targets', (req, res) ->
	fs.readFile 'json/targets.json', (err, data) ->
		res.send JSON.parse(data)

# Start server
if process.env.PORT
	port = process.env.PORT
else
	port = DEV_PORT
	port = PROD_PORT if IS_PRODUCTION
app.listen port

console.log 'Running in context:', process.env.NODE_ENV
console.log 'Started listening on port ' + port
