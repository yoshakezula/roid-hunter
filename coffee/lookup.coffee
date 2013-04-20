Mongolian = require('mongolian')
_ = require('underscore')
sys = require('sys')
path = require('path')
exec = require('child_process').exec
shared_util = require('./shared_util.js')

# #
## Accepted sort fields for top N rankings
##
VALID_SORT_FIELDS = {
	score: -1,
	price: -1,
	saved: -1,
	closeness: -1,
	profit: -1,
}

HOMEPAGE_CACHE_ENABLED = true

topN_query_cache = {}
homepage_summary_result = false
mv = false
mce = false
up = false

# #
# # Grabs the 'top rankings' data for display on the homepage.
# # Lazily cache.
# #
# # @param {function} callback passed err, results
# #
homepage = (cb) ->
	if (HOMEPAGE_CACHE_ENABLED && homepage_summary_result)
		#  poor man's cache
		cb(false, homepage_summary_result)
		return

	console.log('Pulling homepage data...')
	trigger = _.after(3, () ->
		homepage_summary_result = {
			most_valuable: mv,
			most_cost_effective: mce,
			upcoming_passes: up,
		}
		setTimeout(() ->
			homepage_summary_result = null
		, 1000*60*60*12)
		cb(false, homepage_summary_result)
	)

	#  most valuable
	topN({n: 4, sort: 'price'}, (err, result) ->
		mv = result.rankings
		trigger()
	)
	#  most cost effective
	topN({n: 4, sort: 'score'}, (err, result) ->
		mce = result.rankings
		trigger()
	)
	#  upcoming passes
	upcomingPasses(4, (err, result) ->
		up = result
		trigger()
	)

#
# Returns upcoming passes
#
# @param {number} number of results to return
# @param {function} callback
#
upcomingPasses = (num, cb) ->
	db = new Mongolian('localhost/asterank')
	coll = db.collection('jpl')
	coll.find({
		'Next Pass':
			$exists: true
			$ne: null
		'Next Pass.date_iso':
			$gte: new Date().toISOString()
		})
		.sort({'Next Pass.date_iso': 1})
		.limit(num + 50).toArray (err, docs) ->
			results = []
			seen = {}
			if (docs)
				for i of docs
					doc = docs[i]

					continue if (seen[doc.tag_name])

					delete doc._id
					results.push(doc)
					seen[doc.tag_name] = true

			cb(err, results.slice(0, num))


#
# Generates a unique key for a given topN query.
#
# @param {object} parameters for search
# @return {string} key
#
queryToKey = (opts) ->
	return opts.sort + '_' + opts.n + '_' + opts.include_3d_vars + '_' + opts.compact


#
# Returns the top results based on given ranking parameters.
#
# @param {object} parameters for search.
#  Valid parameters: sort, n, include_3d_vars
# @param {function} callback
#
topN = (opts, cb) ->
	opts = opts || {}
	opts.sort = opts.sort || 'score'
	opts.n = opts.n || 10
	opts.include_3d_vars = opts.include_3d_vars || false

	if (!VALID_SORT_FIELDS[opts.sort])
		cb(true, null)
		return

	db = new Mongolian('localhost/asterank')
	coll = db.collection('asteroids')
	sortobj = {}
	sortobj[opts.sort] = VALID_SORT_FIELDS[opts.sort]
	console.log('limit', opts.n)

	query_key = queryToKey(opts)
	if (topN_query_cache[query_key])
		#  present in cache
		console.log('returning query from cache')
		cb(null, topN_query_cache[query_key])
		return

	coll.find().limit(opts.n).sort(sortobj).toArray((err, docs) ->
		if (err)
			cb(true, null)
			return

		#  load asteroid rankings
		args = ['score', 'saved', 'price', 'profit',
			'closeness', 'GM', 'spec_B', 'full_name',
			'moid', 'neo', 'pha', 'diameter', 'inexact', 'dv', 'a', 'e', 'q',
			'prov_des', 'w', ]

		args.push.apply(args, ['i', 'om', 'ma', 'n', 'epoch','tp', 'per'])

		if (opts.compact)
			args.push('fuzzed_price')

		rankings = _.map(docs, (doc) ->
			if (opts.compact)
				ret = []
				_.each args, (arg) ->
					if (arg == 'fuzzed_price')
						ret.push(shared_util.toFuzz(doc.price))
					else
						val = doc[arg]
						ret.push(val)
			else
				ret = _.pick.apply(this, [doc].concat(args))
				ret.fuzzed_price = shared_util.toFuzz(ret.price)

			ret
		)

		#  load composition map
		cmd = path.join(__dirname, '../calc/horizon.py') + ' compositions'
		child = exec(cmd, (error, stdout, stderr) ->
			compositions = null
			if (error)
				console.error(error)
			else
				compositions = JSON.parse(stdout)

			#  cache result
			full_result = {
				rankings: rankings,
				compositions: compositions,
			}

			if (opts.compact)
				full_result.fields = args

			topN_query_cache[query_key] = full_result

			#  send result to client
			cb(null, full_result)
		)
	)

#
# Returns static compositions table
#
compositions = (callback) ->
	#  load composition map
	cmd = path.join(__dirname, '../calc/horizon.py') + ' compositions'
	child = exec cmd, (error, stdout, stderr) ->
		if (error)
			console.error(error)
			callback(true, null)
		else
			compositions = JSON.parse(stdout)
			callback(false, compositions)


#
# Total number of asteroids
#
# @param {function} callback
#
count = (cb) ->
	db = new Mongolian('localhost/asterank')
	coll = db.collection('asteroids')
	coll.count (err, count) ->
		if (err)
			cb(true, null)
			return
		cb(null, count)


#
# JPL query.  Checks the JPL cache and scrapes JPL if necessary.
#
# @param {string} query to search for
# @param {function} callback
#
query = (query, cb) ->
	#  Validate - this stuff will be exec'ed. This is probably a bad idea.
	#  TODO Should switch to using spawn.
	if (!/^[A-Za-z0-9 ]+$/.test(query))
		cb(true, null)
		return
	query = query.trim()

	#  Query JPL database for full information, but check the cache first.
	db = new Mongolian('localhost/asterank')
	coll = db.collection('jpl')
	coll.findOne {tag_name: query}, (err, doc) ->
		if (err || !doc)
			cmd = path.join(__dirname, '../calc/jpl_lookup.py') + ' ' + query
			console.log('Looking up @ JPL:', query, ':', cmd)
			child = exec cmd, (error, stdout, stderr) ->
				if (error)
					console.error(error)
					cb(true, null)
				else
					console.log('start',stdout,'end')
					result = JSON.parse(stdout)
					cb(null, result)
					#  record it in cache
					result.tag_name = query
					coll.insert(result)
		else
			console.log('From JPL cache:', query)
			delete doc._id
			delete doc.tag_name
			cb(null, doc)


#
# Regex lookup
#
# @param {string} query to search for
# @param {function} callback
#
autoComplete = (query, cb, opts) ->
	#  options and defaults
	opts = opts || {}
	opts.full_results = opts.full_results || false
	opts.limit = opts.limit || 8

	db = new Mongolian('localhost/asterank')
	coll = db.collection('asteroids')
	console.log('regex lookup on', query)
	start = +new Date()
	escaped_query = query.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&").replace('+', ' ')
	coll.find {full_name: {$regex: new RegExp(escaped_query, 'i')}}
		.limit(opts.limit)
		.toArray (err, docs) ->
		finish = +new Date()
		console.log('regex lookup on', query, 'returned in', (finish-start)) #, 'ms'
		if (err || !docs)
			cb(true, null)
		else
			matches
			if (opts.full_results)
				matches = _.map docs, (doc) ->
					delete doc._id
					doc
			else
				matches = _.map docs, (doc) ->
					_.pick(doc, 'prov_des', 'full_name')
			cb(false, matches)


sigfig = (num, sig) ->
	if (num == 0)
		return 0
	if (Math.round(num) == num)
		return num
	digits = Math.round((-Math.log(Math.abs(num)) / Math.LN10) + (sig || 2)) # round to significant digits (sig)
	if (digits < 0)
		digits = 0
	if (digits > 20 && num < 1)
		return 0
	return num.toFixed(Math.min(20, digits))


module.exports = {
	topN: topN,
	count: count,
	query: query,
	homepage: homepage,
	autoComplete: autoComplete,
	compositions: compositions,
}
