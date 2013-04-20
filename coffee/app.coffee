express = require('express')
connect = require('connect')
app = express.createServer()
_ = require('underscore')
BundleUp = require('bundle-up')
lookup = require('./lookup.js')
mailer = require('./mailer.js')
fs = require('fs')

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
IS_PRODUCTION = process.env.NODE_ENV == 'production'

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

app.get '/about', (req, res) ->
	# about page
	renderWithContext res, 'about'

app.get '/feedback', (req, res) ->
	# serve feedback form
	renderWithContext res, 'feedback'

app.post '/feedback', (req, res) ->
	# process feedback form
	email = req.body.email
	feedback = req.body.feedback
	mailer.mail(email + ':\r\n' + feedback)
	res.redirect('/')

app.get '/3dtest', (req, res) ->
	renderWithContext(res, '3d')

app.get '/top', (req, res) ->
	fs.readFile 'top.json', (err, data) ->
		res.send JSON.parse(data)


app.get '/summary', (req, res) ->
	# Homepage result summary
	lookup.homepage (err, result) ->
		if err
			res.status(500)
			res.send(result)
		else
			res.send(result)

app.get '/count', (req, res) ->
	# Number of 'roids in the db
	lookup.count num, (err, result) ->
		res.send({n: result})


app.get '/info/:query', (req, res) ->
	# Query info on a specific asteroid
	lookup.query req.params.query, (err, result) ->
		res.send {data: result}


app.get '/search/:q', (req, res) ->
	# Placeholder: search database for any asteroid
	res.send('')

app.get '/autocomplete', (req, res) ->
	# Query info on a specific asteroid
	lookup.autoComplete req.query.query, (err, result) ->
		res.send {data: result}
	, {
		full_results: false,
		limit: 8,
	}

app.get '/compositions', (req, res) ->
	lookup.compositions (err, result) ->
		res.send {data: result}


app.post '/subscribe', (req, res) ->
	# Mail me to subscribe
	email = req.body.email
	mailer.mail('subscribe ' + email)
	res.redirect('/')

renderWithContext = (res, template, obj) ->
	# Add a global context to all templates
	obj = {} if (!obj)
	obj.context = {
		layout: 'layout',
		production: IS_PRODUCTION,
	}
	res.render template, obj

# Start server
port = process.env.PORT || (IS_PRODUCTION ? PROD_PORT : DEV_PORT)
app.listen port

console.log 'Running in context:', process.env.NODE_ENV
console.log 'Started listening on port ' + port
